local M = {}

local function warn(message) vim.notify(message, vim.log.levels.WARN, { title = "Codex" }) end

local function kitty(args, stdin)
	local command = vim.list_extend({ "kitten", "@" }, args)
	local result = vim.system(command, { text = true, stdin = stdin }):wait(2000)
	if result.code ~= 0 then
		local message = vim.trim(result.stderr or "")
		warn(message ~= "" and message or "Kitty remote control failed")
		return
	end
	return vim.trim(result.stdout or "")
end

local function project_root()
	local source = vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) or ""
	local root = vim.fs.root(source ~= "" and source or vim.fn.getcwd(), ".git") or vim.fn.getcwd()
	return vim.uv.fs_realpath(root) or root
end

local function window(root, create)
	local editor = vim.env.KITTY_WINDOW_ID
	if not editor or vim.fn.executable("kitten") ~= 1 then
		warn("Open Neovim in Kitty to use Codex")
		return
	end
	local output = kitty({ "ls" })
	if not output then
		return
	end
	local ok, windows = pcall(vim.json.decode, output)
	if not ok then
		warn("Could not read Kitty windows")
		return
	end
	local editor_tab
	for _, os_window in ipairs(windows) do
		for _, tab in ipairs(os_window.tabs) do
			for _, pane in ipairs(tab.windows) do
				if tostring(pane.id) == editor then
					editor_tab = tab
				end
				local vars = pane.user_vars or {}
				if (root == nil or vars.NVIM_CODEX_ROOT == root) and vars.NVIM_CODEX_EDITOR == editor then
					local processes =
						vim.list_extend({ { cmdline = pane.cmdline or {} } }, pane.foreground_processes or {})
					for _, process in ipairs(processes) do
						if vim.fs.basename((process.cmdline or {})[1] or "") == "codex" then
							return pane.id, tab.layout, tab
						end
					end
				end
			end
		end
	end
	if create == false then
		return nil, editor_tab and editor_tab.layout, editor_tab
	end
	if editor_tab and editor_tab.layout == "stack" then
		kitty({ "action", "--match=id:" .. editor, "last_used_layout" })
	end
	local id = kitty({
		"launch",
		"--type=window",
		"--location=vsplit",
		"--match=window_id:" .. editor,
		"--next-to=id:" .. editor,
		"--cwd=" .. root,
		"--var=NVIM_CODEX_ROOT=" .. root,
		"--var=NVIM_CODEX_EDITOR=" .. editor,
		"codex",
		"resume",
		"--remote",
		"unix://",
		"--last",
		"--cd",
		root,
		"-c",
		"tui.fullscreen_transcript=true",
		"-c",
		'tui.notification_method="osc9"',
	})
	return id and tonumber(id)
end

local function focus(id) kitty({ "focus-window", "--match=id:" .. id }) end

local function show(id, layout)
	if layout == "stack" then
		kitty({ "action", "--match=id:" .. id, "last_used_layout" })
	end
	focus(id)
end

local function send(text)
	local id, layout = window(project_root())
	if not id then
		return
	end
	show(id, layout)
	-- A new CLI may still be starting. Wait for its composer before pasting.
	local attempts = 0
	local function paste()
		local screen = kitty({ "get-text", "--match=id:" .. id })
		if not screen then
			return
		end
		if screen:find("›", 1, true) then
			if kitty({ "send-text", "--match=id:" .. id, "--bracketed-paste=enable", "--stdin" }, text .. "\n") then
				focus(id)
			end
		elseif attempts < 30 then
			attempts = attempts + 1
			vim.defer_fn(paste, 100)
		else
			warn("Codex is not ready for input; finish its startup, then send again")
		end
	end
	paste()
end

local function reference()
	local name = vim.api.nvim_buf_get_name(0)
	if name == "" or vim.bo.buftype ~= "" then
		warn("Choose a named file first")
		return
	end
	if vim.bo.modified then
		warn("This buffer has unsaved changes; a file reference points to the version on disk")
	end
	return "@" .. (vim.fs.relpath(project_root(), name) or name)
end

function M.open()
	local id, layout = window(project_root())
	if id then
		show(id, layout)
	end
end

function M.toggle()
	local id, layout = window(project_root(), false)
	if id and layout ~= "stack" then
		focus(vim.env.KITTY_WINDOW_ID)
		kitty({ "goto-layout", "--match=window_id:" .. vim.env.KITTY_WINDOW_ID, "stack" })
	else
		M.open()
	end
end

local zoomed_tab, scheduled = nil, false

local function float_focus()
	if not vim.env.KITTY_WINDOW_ID or #vim.api.nvim_list_uis() == 0 then
		return
	end
	local config = vim.api.nvim_win_get_config(0)
	local floating = config.relative ~= "" and not config.external
	if not floating and not zoomed_tab then
		return
	end
	local id, layout, tab = window(nil, false)
	if not tab then
		return
	end
	local active = false
	for _, pane in ipairs(tab.windows) do
		if tostring(pane.id) == vim.env.KITTY_WINDOW_ID then
			active = pane.is_active and tab.is_active
			break
		end
	end
	-- Keep the restore record while focus is elsewhere; retry on FocusGained.
	if not active then
		return
	end
	if floating then
		if id and layout ~= "stack" then
			if kitty({ "goto-layout", "--match=window_id:" .. vim.env.KITTY_WINDOW_ID, "stack" }) then
				zoomed_tab = { id = tab.id, layout = layout }
			end
		end
	elseif zoomed_tab then
		if tab.id ~= zoomed_tab.id or layout ~= "stack" then
			zoomed_tab = nil
		elseif kitty({ "goto-layout", "--match=window_id:" .. vim.env.KITTY_WINDOW_ID, zoomed_tab.layout }) then
			zoomed_tab = nil
		end
	end
end

local group = vim.api.nvim_create_augroup("CodexFloatFocus", { clear = true })
vim.api.nvim_create_autocmd(
	{ "VimEnter", "WinEnter", "WinClosed", "TermClose", "TabEnter", "FocusGained", "VimResized" },
	{
		group = group,
		callback = function()
			if scheduled then
				return
			end
			scheduled = true
			-- Float layouts can create or close several windows in one operation.
			-- TermClose handlers can close windows without nested window events.
			vim.schedule(function()
				scheduled = false
				float_focus()
			end)
		end,
		desc = "Temporarily maximize Kitty while a Neovim float has focus",
	}
)

function M.file()
	local ref = reference()
	if ref then
		send(ref)
	end
end

function M.position()
	if vim.fn.mode():match("[vV\22]") then
		return M.selection()
	end
	local ref = reference()
	if ref then
		local cursor = vim.api.nvim_win_get_cursor(0)
		send(("%s :L%d:C%d"):format(ref, cursor[1], cursor[2] + 1))
	end
end

function M.selection()
	local mode = vim.fn.mode()
	if not mode:match("[vV\22]") then
		return
	end
	local from, to = vim.fn.getpos("v"), vim.fn.getpos(".")
	local lines = vim.fn.getregion(from, to, { type = mode })
	local name = vim.api.nvim_buf_get_name(0)
	local ref = name ~= "" and ("@" .. (vim.fs.relpath(project_root(), name) or name)) or "Selection"
	local first, last = math.min(from[2], to[2]), math.max(from[2], to[2])
	local text = ("%s :L%d-L%d\n```%s\n%s\n```"):format(ref, first, last, vim.bo.filetype, table.concat(lines, "\n"))
	vim.cmd.normal({ "\27", bang = true })
	send(text)
end

vim.keymap.set({ "n", "i", "x", "t" }, "<C-.>", M.toggle, { desc = "Toggle Codex in Kitty" })
vim.keymap.set("n", "<leader>af", M.file, { desc = "Send File to Codex" })
vim.keymap.set({ "n", "x" }, "<leader>at", M.position, { desc = "Send Position to Codex" })

return M
