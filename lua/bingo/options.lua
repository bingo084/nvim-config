vim.g.use_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.opt.showmatch = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

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
