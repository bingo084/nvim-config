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
	callback = function() vim.cmd("checktime") end,
	desc = "Reload buffer if it's changed externally",
})

vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
	group = group,
	callback = function(args)
		if next(vim.lsp.get_clients({ bufnr = args.buf })) then
			vim.lsp.codelens.refresh({ bufnr = args.buf })
		end
	end,
	desc = "Refresh code lens",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(args) vim.lsp.inlay_hint.enable(true, { bufnr = args.buf }) end,
	desc = "Enable inlay hints",
})
