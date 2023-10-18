return {
	"lukas-reineke/indent-blankline.nvim",
	dependencies = { "HiPhish/rainbow-delimiters.nvim" },
	config = function()
		require("ibl").setup({
			debounce = 100,
			indent = { char = "▏" },
			scope = {
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			},
		})
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
		hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
	end,
	event = "VeryLazy",
	keys = {
		{ "<leader>oi", "<cmd>IBLToggle<cr>", desc = "Toggle Indent Blankline" },
	},
}
