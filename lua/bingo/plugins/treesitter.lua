return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"p00f/nvim-ts-rainbow",
		"windwp/nvim-ts-autotag",
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = "all", -- one of "all" or a list of languages
			sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
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
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			autotag = {
				enable = true,
				disable = { "xml", "markdown" },
			},
			rainbow = {
				enable = true,
				disable = { "html" },
			},
		})
	end,
	event = "VeryLazy",
	keys = {
		{ "<leader>Tr", "<cmd>TSToggle rainbow<cr>", desc = "Treesitter Rainbow" },
	},
}