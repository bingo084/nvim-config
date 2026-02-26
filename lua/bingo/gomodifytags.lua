local M = {}

---@alias GomodifytagsTransform "snakecase"|"camelcase"|"lispcase"|"pascalcase"|"titlecase"|"keep"

---@class GomodifytagsConfig
---@field default_tag string
---@field skip_unexported boolean
---@field sort boolean
---@field fallback_transform GomodifytagsTransform
---@field tag_transforms table<string, GomodifytagsTransform>
---@field tag_templates table<string, string> {field} is replaced by the transformed field name
local defaults = {
	default_tag = "json",
	skip_unexported = true,
	sort = true,
	fallback_transform = "camelcase",
	tag_transforms = {
		json = "camelcase",
		yaml = "camelcase",
		gorm = "snakecase",
		db = "snakecase",
		xml = "pascalcase",
		mapstructure = "snakecase",
		toml = "snakecase",
		form = "snakecase",
		binding = "snakecase",
	},
	tag_templates = {},
}

M.config = vim.deepcopy(defaults)

local function get_struct_name()
	local node = vim.treesitter.get_node()
	while node do
		if node:type() == "type_spec" then
			for child in node:iter_children() do
				if child:type() == "struct_type" then
					local name_node = node:child(0)
					if name_node then
						return vim.treesitter.get_node_text(name_node, 0)
					end
				end
			end
		end
		node = node:parent()
	end
	return nil
end

local function get_transform(tag) return M.config.tag_transforms[tag] or M.config.fallback_transform end

local function build_cmd(file, action, tag, scope, override)
	local cmd = { "gomodifytags", "-file", file, "-format", "json" }

	if scope.line1 and scope.line2 then
		table.insert(cmd, "-line")
		table.insert(cmd, scope.line1 .. "," .. scope.line2)
	elseif scope.struct_name then
		table.insert(cmd, "-struct")
		table.insert(cmd, scope.struct_name)
	else
		return nil
	end

	if action == "add" then
		table.insert(cmd, "-add-tags")
		table.insert(cmd, tag)
		local transform = get_transform(tag)
		table.insert(cmd, "-transform")
		table.insert(cmd, transform)
		local template = M.config.tag_templates[tag]
		if template then
			table.insert(cmd, "-template")
			table.insert(cmd, template)
		end
	elseif action == "remove" then
		table.insert(cmd, "-remove-tags")
		table.insert(cmd, tag)
	elseif action == "clear" then
		table.insert(cmd, "-clear-tags")
	end

	if M.config.skip_unexported then
		table.insert(cmd, "-skip-unexported")
	end
	if override then
		table.insert(cmd, "-override")
	end
	if M.config.sort then
		table.insert(cmd, "-sort")
	end

	return cmd
end

local function execute(cmd, callback)
	vim.system(
		cmd,
		{ text = true },
		vim.schedule_wrap(function(job)
			if job.code ~= 0 then
				vim.notify("gomodifytags: " .. (job.stderr or "unknown error"), vim.log.levels.ERROR)
				if callback then
					callback(false)
				end
				return
			end

			local ok, result = pcall(vim.json.decode, job.stdout)
			if not ok or not result then
				vim.notify("gomodifytags: failed to parse output", vim.log.levels.ERROR)
				if callback then
					callback(false)
				end
				return
			end

			if result.errors then
				vim.notify("gomodifytags: " .. vim.inspect(result.errors), vim.log.levels.ERROR)
				if callback then
					callback(false)
				end
				return
			end

			if result.lines and result.start then
				for i, line in ipairs(result.lines) do
					result.lines[i] = line:gsub("%s+$", "")
				end
				vim.api.nvim_buf_set_lines(0, result.start - 1, result.start - 1 + #result.lines, false, result.lines)
			end
			if callback then
				callback(true)
			end
		end)
	)
end

local function ensure_saved()
	if vim.bo.modified then
		vim.cmd("silent update")
	end
end

local function resolve_scope(cmd_opts)
	if cmd_opts.range > 0 then
		return { line1 = cmd_opts.line1, line2 = cmd_opts.line2 }
	end

	local struct_name = get_struct_name()
	if struct_name then
		return { struct_name = struct_name }
	end

	local line = vim.fn.line(".")
	return { line1 = line, line2 = line }
end

local function parse_tags(fargs)
	local tags = {}
	for _, arg in ipairs(fargs) do
		for tag in arg:gmatch("[^,]+") do
			table.insert(tags, tag)
		end
	end
	return tags
end

local function add_tags_sequentially(file, tags, scope, override, index)
	index = index or 1
	if index > #tags then
		return
	end

	local tag = tags[index]
	local cmd = build_cmd(file, "add", tag, scope, override)
	if not cmd then
		return
	end

	execute(cmd, function(success)
		if success and index < #tags then
			vim.defer_fn(function()
				ensure_saved()
				add_tags_sequentially(file, tags, scope, override, index + 1)
			end, 50)
		end
	end)
end

function M.add_tags(cmd_opts)
	ensure_saved()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("gomodifytags: buffer has no file", vim.log.levels.ERROR)
		return
	end

	local scope = resolve_scope(cmd_opts)
	local tags = parse_tags(cmd_opts.fargs)

	if #tags == 0 then
		tags = { M.config.default_tag }
	end
	add_tags_sequentially(file, tags, scope, cmd_opts.bang)
end

function M.remove_tags(cmd_opts)
	ensure_saved()
	local file = vim.api.nvim_buf_get_name(0)
	if file == "" then
		vim.notify("gomodifytags: buffer has no file", vim.log.levels.ERROR)
		return
	end
	local scope = resolve_scope(cmd_opts)

	if #cmd_opts.fargs > 0 then
		local cmd = build_cmd(file, "remove", table.concat(cmd_opts.fargs, ","), scope, false)
		if cmd then
			execute(cmd)
		end
	else
		local cmd = build_cmd(file, "clear", nil, scope, false)
		if cmd then
			execute(cmd)
		end
	end
end

return M
