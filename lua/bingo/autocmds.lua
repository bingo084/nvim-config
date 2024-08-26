local group = vim.api.nvim_create_augroup("custom", {})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	callback = function() vim.opt.formatoptions:remove({ "r", "o" }) end,
	desc = "Disable automatic comment insertion",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function() vim.highlight.on_yank() end,
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
	callback = function() vim.cmd("checktime") end,
	desc = "Reload buffer if it's changed externally",
})
