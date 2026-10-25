local group = vim.api.nvim_create_augroup("custom", {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function() vim.opt.formatoptions:remove({ "r", "o" }) end,
	desc = "Disable automatic comment insertion",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function() vim.hl.on_yank() end,
	desc = "Highlight when yanking (copying) text",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/[^.]*",
	group = group,
	callback = function() vim.cmd("!chezmoi apply --source-path %") end,
	desc = "Chezmoi apply after write",
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = group,
	callback = function()
		if vim.fn.getcmdwintype() ~= "" or vim.bo.buftype ~= "" then
			return
		end
		vim.cmd("checktime")
	end,
	desc = "Reload buffer if it's changed externally",
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
	group = group,
	callback = function(args)
		vim.keymap.set("n", "<S-CR>", "<CR>q:", { buffer = args.buf, desc = "Execute command and reopen cmdwin" })
	end,
	desc = "Cmdwin: map <S-CR> to execute and reopen",
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = function()
		if vim.env.KITTY_WINDOW_ID then
			local title = vim.fs.basename(vim.fn.getcwd())
			vim.system({ "kitten", "@", "set-window-title", "--temporary", title }, { detach = true })
		end
	end,
	desc = "Set kitty tab title to working directory on startup",
})

local kitty_title_buf

local function set_kitty_title(title) vim.api.nvim_ui_send("\27]0;" .. title .. "\7") end

vim.api.nvim_create_autocmd("TermRequest", {
	group = group,
	callback = function(args)
		if not vim.env.KITTY_WINDOW_ID or not vim.api.nvim_ui_send then
			return
		end
		local tool = vim.b[args.buf].sidekick_cli
		if not tool or tool.name ~= "codex" then
			return
		end
		local title = args.data.sequence:match("^\27%][02];(.*)$")
		if title then
			kitty_title_buf = args.buf
			set_kitty_title(title ~= "" and title or vim.fs.basename(vim.fn.getcwd()))
		end
		local notification = args.data.sequence:match("^\27%]9;(.*)$")
		-- OSC 9;4 is a progress update, not a notification.
		if notification and not notification:match("^4;") then
			vim.api.nvim_ui_send("\27]99;o=unfocused;" .. notification .. "\7")
		end
	end,
	desc = "Forward Sidekick Codex title and notifications to Kitty",
})

vim.api.nvim_create_autocmd({ "TermClose", "BufWipeout" }, {
	group = group,
	callback = function(args)
		if args.buf == kitty_title_buf then
			kitty_title_buf = nil
			set_kitty_title(vim.fs.basename(vim.fn.getcwd()))
		end
	end,
	desc = "Restore Kitty title when Sidekick Codex exits",
})

vim.api.nvim_create_autocmd("VimLeave", {
	group = group,
	callback = function()
		if vim.env.KITTY_WINDOW_ID then
			vim.system({ "kitten", "@", "set-tab-title" }, { detach = true })
			vim.system({ "kitten", "@", "set-window-title" }, { detach = true })
		end
	end,
	desc = "Set kitty tab title to default on exit",
})
