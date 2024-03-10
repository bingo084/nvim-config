local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("bingo.plugins", {
	defaults = {
		version = "*",
	},
	install = {
		colorscheme = { "catppuccin" },
	},
	ui = {
		border = "rounded",
	},
	checker = {
		enabled = true,
		frequency = 86400,
	},
})

local map = require("bingo.utils").map
local lazy = require("lazy")
map("n", "<leader>pc", function() lazy.check() end, "[P]lugin [C]heck")
map("n", "<leader>pd", function() lazy.debug() end, "[P]lugin [D]ebug")
map("n", "<leader>ph", function() lazy.home() end, "[P]lugin [H]ome")
map("n", "<leader>pl", function() lazy.log() end, "[P]lugin [L]og")
map("n", "<leader>pp", function() lazy.profile() end, "[P]lugin [P]rofile")
map("n", "<leader>pu", function() lazy.update() end, "[P]lugin [U]pdate")
