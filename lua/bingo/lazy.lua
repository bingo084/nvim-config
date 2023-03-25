local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- remap space as leader key
vim.g.mapleader = " "
local config = {
	checker = {
		-- automatically check for plugin updates
		enabled = true,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = true, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
	},
}
require("lazy").setup("bingo.plugins", config)
local map = require("bingo.functions").map
map("n", "<leader>ph", "<cmd>Lazy<cr>", "Plugin Home")
map("n", "<leader>pp", "<cmd>Lazy profile<cr>", "Plugin Profile")
