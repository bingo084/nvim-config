---@type LazySpec
return {
	"rachartier/tiny-code-action.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		backend = "delta",
		backend_opts = {
			delta = {
				args = {
					"--tabs=" .. vim.bo.tabstop,
				},
			},
		},
		picker = {
			"buffer",
			opts = {
				hotkeys = true,
				auto_accept = true,
				keymaps = {
					close = { "q", "<Esc>" },
				},
				custom_keys = {
					{ key = "m", pattern = "Fill match arms" },
					{ key = "m", pattern = "Consider making this binding mutable: mut" },
					{ key = "r", pattern = "Rename.*" },
					{ key = "e", pattern = "Extract Method" },
				},
				group_icon = " └",
			},
		},
	},
	event = "LspAttach",
}
