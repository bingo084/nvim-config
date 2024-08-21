local function builtin() return require("telescope.builtin") end
local function actions() return require("telescope.actions") end
local function layout() return require("telescope.actions.layout") end
local function mappings(map)
	return vim.tbl_extend("force", {
		["<C-n>"] = actions().move_selection_next,
		["<C-p>"] = actions().move_selection_previous,
		["<C-e>"] = actions().close,
		["<C-s>"] = actions().select_horizontal,
		["<C-u>"] = actions().results_scrolling_up,
		["<C-d>"] = actions().results_scrolling_down,
		["<A-u>"] = actions().preview_scrolling_up,
		["<A-d>"] = actions().preview_scrolling_down,
		["<A-q>"] = actions().send_selected_to_qflist + actions().open_qflist,
		["<C-j>"] = actions().cycle_history_next,
		["<C-k>"] = actions().cycle_history_prev,
		["<A-p>"] = layout().toggle_preview,
	}, map or {})
end
---@type LazySpec
return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", version = false },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				config = function() require("telescope").load_extension("fzf") end,
			},
			{
				"nvim-telescope/telescope-ui-select.nvim",
				config = function() require("telescope").load_extension("ui-select") end,
			},
		},
		config = function()
			require("telescope").setup({
				defaults = require("telescope.themes").get_dropdown({
					scroll_strategy = "limit",
					prompt_prefix = " 󰍉 ",
					selection_caret = "  ",
					entry_prefix = "   ",
					multi_icon = "  ",
					path_display = { "smart" },
					dynamic_preview_title = true,
					mappings = {
						i = mappings(),
						n = mappings({ ["q"] = actions().close, ["H"] = false, ["L"] = false }),
					},
				}),
				pickers = {
					buffers = {
						mappings = { n = { ["dd"] = actions().delete_buffer } },
						previewer = false,
						initial_mode = "normal",
					},
					colorscheme = {
						theme = "cursor",
						enable_preview = true,
					},
					find_files = {
						previewer = false,
					},
					lsp_definitions = {
						show_line = false,
						path_display = { "tail" },
					},
					lsp_implementations = {
						show_line = false,
						path_display = { "tail" },
					},
					lsp_references = {
						include_declaration = false,
						show_line = false,
						path_display = { "tail" },
					},
				},
			})
		end,
		cmd = "Telescope",
		keys = {
			{ "<leader>fa", function() builtin().autocommands() end, desc = "[F]ind [A]utocommands" },
			{ "<leader>fb", function() builtin().buffers() end, desc = "[F]ind [B]uffer" },
			{ "<leader>fc", function() builtin().command_history() end, desc = "[F]ind [C]ommand History" },
			{ "<leader>ff", function() builtin().find_files() end, desc = "[F]ind [F]ile" },
			{
				"<leader>fF",
				function() builtin().find_files({ hidden = true, no_ignore = true }) end,
				desc = "[F]ind All [F]ile",
			},
			{ "<leader>fh", function() builtin().help_tags() end, desc = "[F]ind [H]elp" },
			{ "<leader>fH", function() builtin().highlights() end, desc = "[F]ind [H]ighlights" },
			{ "<leader>fk", function() builtin().keymaps() end, desc = "[F]ind [K]eymaps" },
			{ "<leader>fl", function() builtin().resume() end, desc = "[F]ind [L]ast Search" },
			{ "<leader>fm", function() builtin().man_pages() end, desc = "[F]ind [M]an Pages" },
			{ "<leader>fo", function() builtin().vim_options() end, desc = "[F]ind [O]ptions" },
			{ "<leader>ft", function() builtin().live_grep() end, desc = "[F]ind [T]ext" },
			{ "<leader>fw", function() builtin().grep_string() end, desc = "[F]ind [W]ord" },
		},
	},
	{
		"nvim-telescope/telescope-symbols.nvim",
		keys = {
			{ "<leader>fi", function() builtin().symbols() end, desc = "[F]ind [I]con" },
		},
	},
}
