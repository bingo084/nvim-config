---@type LazySpec
return {
	{
		"saghen/blink.pairs",
		dependencies = "saghen/blink.download",
		init = function() vim.keymap.set({ "i", "c" }, "<C-h>", "<BS>", { remap = true }) end,
		--- @module 'blink.pairs'
		--- @type blink.pairs.Config
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
