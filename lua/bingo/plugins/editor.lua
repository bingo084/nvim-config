---@type LazySpec
return {
	{
		"norcalli/nvim-colorizer.lua",
		config = function() require("colorizer").setup({ "*" }, { css = true }) end,
		ft = { "css" },
		keys = {
			{ "<leader>oc", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer" },
		},
	},
	{
		"numToStr/Comment.nvim",
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
		},
		version = false,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		},
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				modes_denylist = { "v" },
				large_file_cutoff = 5000,
			})
		end,
		event = "VeryLazy",
		keys = {
			{ "<leader>oh", function() require("illuminate").toggle() end, desc = "Toggle Doc HL" },
		},
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = true,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = { char = "▏", tab_char = "▏" },
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
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		version = false,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = { enable = true },
				autopairs = { enable = true },
				indent = { enable = true },
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
						},
					},
				},
			})
		end,
		event = "VeryLazy",
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		main = "rainbow-delimiters.setup",
		opts = {
			query = {
				lua = "rainbow-blocks",
			},
		},
		event = "BufReadPost",
		keys = {
			{ "<leader>oR", function() require("rainbow-delimiters").toggle(0) end, desc = "Toggle Rainbow" },
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		build = function() vim.fn["mkdp#util#install"]() end,
		version = false,
		ft = { "markdown" },
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Preview" },
		},
	},
	{ "dhruvasagar/vim-table-mode", cmd = "TableModeEnable" },
	{
		"JuanZoran/Trans.nvim",
		dependencies = { { "kkharji/sqlite.lua", version = false } },
		build = function() require("Trans").install() end,
		opts = {
			frontend = {
				default = {
					title = {
						{ "", "TransTitleRound" },
						{ "󰊿 Trans", "TransTitle" },
						{ "", "TransTitleRound" },
					},
					auto_play = false,
				},
				hover = { keymaps = { pin = "<A-p>", close = "q" }, icon = { notfound = "󰠗" } },
			},
		},
		keys = {
			{ "mm", vim.cmd.Translate, mode = { "n", "x" }, desc = "󰗊 Translate" },
			{ "mk", vim.cmd.TransPlay, mode = { "n", "x" }, desc = " Auto Play" },
			{ "mi", vim.cmd.TranslateInput, desc = "󰊿 Translate From Input" },
		},
	},
	{
		"Jay-Madden/auto-fix-return.nvim",
		opts = {},
		ft = "go",
	},
	{ "wakatime/vim-wakatime", lazy = false },
}
