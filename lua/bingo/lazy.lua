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

local function nmap(key, action, desc)
	local opts = { desc = desc }
	vim.keymap.set("n", key, action, opts)
end
local lazy = require("lazy")
nmap("<leader>pc", function() lazy.check() end, "[P]lugin [C]heck")
nmap("<leader>pd", function() lazy.debug() end, "[P]lugin [D]ebug")
nmap("<leader>ph", function() lazy.home() end, "[P]lugin [H]ome")
nmap("<leader>pl", function() lazy.log() end, "[P]lugin [L]og")
nmap("<leader>pp", function() lazy.profile() end, "[P]lugin [P]rofile")
nmap("<leader>pu", function() lazy.update() end, "[P]lugin [U]pdate")
