return {
	"folke/which-key.nvim",
	opts = {
		window = {
			border = "rounded",
		},
		layout = {
			align = "center",
		},
	},
	config = function(_, opts)
		local which_key = require("which-key")
		local mappings = {
			b = { name = "Buffer" },
			d = { name = "Debug" },
			f = { name = "Find" },
			g = { name = "Git" },
			l = { name = "Lsp" },
			m = { name = "Markdown" },
			o = { name = "Options" },
			p = { name = "Plugin" },
			s = { name = "Session" },
			t = { name = "Terminal" },
			T = { name = "Treesitter" },
		}
		which_key.setup(opts)
		which_key.register(mappings, { prefix = "<leader>" })
	end,
	event = "VeryLazy",
}
