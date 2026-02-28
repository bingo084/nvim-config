local ok, registry = pcall(require, "mason-registry")
if not ok then
	return { outdated = {}, get_text = function() return "" end, has_updates = function() return false end }
end

local M = {}

M.outdated = {}

local function check()
	registry.refresh(function()
		local outdated = {}
		for _, pkg in ipairs(registry.get_installed_packages()) do
			local installed = pkg:get_installed_version()
			local latest = pkg:get_latest_version()
			if installed ~= latest then
				table.insert(outdated, { name = pkg.name, current = installed, latest = latest })
			end
		end
		M.outdated = outdated
		if #outdated > 0 then
			local lines = { "# Package Updates" }
			for _, pkg in ipairs(outdated) do
				table.insert(lines, "- **" .. pkg.name .. "**")
			end
			vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, { title = "mason.nvim" })
		end
		if package.loaded.lualine then
			require("lualine").refresh({ place = { "statusline" } })
		end
	end)
end

function M.get_text()
	local n = #M.outdated
	return n > 0 and (n .. "") or ""
end

function M.has_updates() return #M.outdated > 0 end

local timer = vim.uv.new_timer()
if timer then
	timer:start(0, 3600000, vim.schedule_wrap(check))
end

registry:on("package:install:success", vim.schedule_wrap(check))
registry:on("package:uninstall:success", vim.schedule_wrap(check))

vim.api.nvim_create_autocmd("VimLeave", {
	callback = function()
		if timer and not timer:is_closing() then
			timer:stop()
			timer:close()
		end
	end,
})

return M
