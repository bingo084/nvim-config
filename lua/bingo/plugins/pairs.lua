---@type LazySpec
return {
	{
		"saghen/blink.pairs",
		dependencies = "saghen/blink.lib",
		build = function()
			---@module "blink.lib"
			require("blink.pairs").download():pwait(60000)
		end,
		init = function() vim.keymap.set({ "i", "c" }, "<C-h>", "<BS>", { remap = true }) end,
		---@module 'blink.pairs'
		---@type blink.pairs.Config
		opts = {
			highlights = {
				enabled = false,
			},
		},
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
		event = "InsertEnter",
	},
}
