vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("disable-comment-auto-insertion", {}),
	callback = function() vim.opt.formatoptions:remove({ "r", "o" }) end,
	desc = "Disable automatic comment insertion",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-on-yank", {}),
	callback = function() vim.highlight.on_yank() end,
	desc = "Highlight when yanking (copying) text",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
	group = vim.api.nvim_create_augroup("chezmoi-apply-after-write", {}),
	callback = function()
		vim.cmd("silent!chezmoi apply --source-path %")
    vim.notify("Chezmoi apply file")
	end,
	desc = "Chezmoi apply after write",
})
