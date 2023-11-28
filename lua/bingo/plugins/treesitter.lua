return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
			"windwp/nvim-ts-autotag",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
				auto_install = true, -- Automatically install missing parsers when entering buffer
				ignore_install = { "" }, -- List of parsers to ignore installing
				highlight = {
					-- use_languagetree = true,
					enable = true, -- false will disable the whole extension
					-- disable = { "css", "html" }, -- list of language that will be disabled
					-- disable = { "css", "markdown" }, -- list of language that will be disabled
					disable = { "markdown" }, -- list of language that will be disabled
					-- additional_vim_regex_highlighting = true,
				},
				autopairs = {
					enable = true,
				},
				indent = { enable = true, disable = { "python", "css", "rust", "java" } },
				autotag = {
					enable = true,
					disable = { "xml", "markdown" },
				},
			})
		end,
		event = "VeryLazy",
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")
			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = rainbow_delimiters.strategy["global"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
			}
		end,
		event = "VeryLazy",
		keys = {
			{ "<leader>oR", "<cmd>lua require('rainbow-delimiters').toggle()<cr>", desc = "Toggle Rainbow" },
		},
	},
}
