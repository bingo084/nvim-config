return {
	{
		"alker0/chezmoi.vim",
		init = function()
			if os.getenv("CHEZMOI") == "1" then
				require("notify")("Using chezmoi edit file")
			end
		end,
		cond = function() return vim.fn.expand("%:p"):match("chezmoi") ~= nil end,
		config = function() vim.g["chezmoi#use_tmp_buffer"] = true end,
	},
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
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end
				local function navimap(l, r, desc)
					vim.keymap.set("n", l, function()
						if vim.wo.diff then
							return l
						end
						vim.schedule(r)
						return "<Ignore>"
					end, { buffer = bufnr, desc = desc, expr = true })
				end
				navimap("]c", gs.next_hunk, "[N]ext [C]hange(hunk)")
				navimap("[c", gs.prev_hunk, "[P]rev [C]hange(hunk)")
				map("n", "<leader>gb", gs.blame_line, "[G]it [B]lame")
				map("n", "<leader>gp", gs.preview_hunk, "[G]it [P]review")
				map("n", "<leader>gr", gs.reset_hunk, "[G]it [R]eset hunk")
				map("n", "<leader>gR", gs.reset_buffer, "[G]it [R]eset buffer")
				map("n", "<leader>gs", gs.stage_hunk, "[G]it [S]tage hunk")
				map("n", "<leader>gS", gs.stage_buffer, "[G]it [S]tage hunk")
				local range = { vim.fn.line("."), vim.fn.line("v") }
				map("v", "<leader>gr", function() gs.reset_hunk(range) end, "[G]it [R]eset hunk")
				map("v", "<leader>gs", function() gs.stage_hunk(range) end, "[G]it [S]tage hunk")
				map("n", "<leader>gu", gs.undo_stage_hunk, "[G]it [U]ndo stage hunk")
				-- Text object
				map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<CR>", "git hunk")
			end,
		},
		event = "VeryLazy",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-context",
		},
		build = ":TSUpdate",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				highlight = { enable = true },
				autopairs = { enable = true },
				indent = { enable = true },
				autotag = { enable = true },
			})
		end,
		event = "VeryLazy",
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		version = false,
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
		ft = { "markdown" },
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle [M]arkdown [P]review" },
		},
	},
	{ "dhruvasagar/vim-table-mode", cmd = "TableModeEnable" },
}
