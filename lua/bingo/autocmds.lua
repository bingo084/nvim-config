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
			vim.system({ "kitten", "@", "set-tab-title", title }, { detach = true })
		end
	end,
	desc = "Set kitty tab title to working directory on startup",
})

vim.api.nvim_create_autocmd("VimLeave", {
	group = group,
	callback = function()
		if vim.env.KITTY_WINDOW_ID then
			vim.system({ "kitten", "@", "set-tab-title" }, { detach = true })
		end
	end,
	desc = "Set kitty tab title to default on exit",
})
