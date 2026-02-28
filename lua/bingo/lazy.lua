local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
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
	},
})

local function nmap(key, action, desc)
	local opts = { desc = desc }
	vim.keymap.set("n", key, action, opts)
end
local lazy = require("lazy")
nmap("<leader>pc", function() lazy.check() end, "Check")
nmap("<leader>pd", function() lazy.debug() end, "Debug")
nmap("<leader>ph", function() lazy.home() end, "Home")
nmap("<leader>pl", function() lazy.log() end, "Log")
nmap("<leader>pp", function() lazy.profile() end, "Profile")
nmap("<leader>pu", function() lazy.update() end, "Update")
