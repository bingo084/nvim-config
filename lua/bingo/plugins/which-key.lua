---@type LazySpec
return {
	"folke/which-key.nvim",
	version = "*",
	---@class wk.Opts
	opts = {
		---@type false | "classic" | "modern" | "helix"
		preset = "modern",
		--- You can add any mappings here, or use `require('which-key').add()` later
		---@type wk.Spec
		spec = {
			{ "<leader>c", group = "Copilot" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>i", group = "Inline" },
			{ "<leader>l", group = "Lsp" },
			{ "<leader>m", group = "Markdown" },
			{ "<leader>n", group = "Notification" },
			{ "<leader>o", group = "Options" },
			{ "<leader>p", group = "Plugin" },
			{ "<leader>r", group = "Reload" },
			{ "<leader>s", group = "Session" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>T", group = "Treesitter" },
			{ "<leader>x", group = "Extract" },
		},
	},
	event = "VeryLazy",
}
