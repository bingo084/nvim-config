return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local layout = require("telescope.actions.layout")
		local actions = require("telescope.actions")
		local icons = require("bingo.icons")

		require("telescope").setup({
			defaults = require("telescope.themes").get_dropdown({
				prompt_prefix = " " .. icons.ui.Telescope .. " ",
				selection_caret = " ",
				path_display = { "smart" },
				dynamic_preview_title = true,
				mappings = {
					i = {
						["<C-n>"] = actions.move_selection_next,
						["<C-p>"] = actions.move_selection_previous,
						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,

						["<C-e>"] = actions.close,
						["<Esc>"] = actions.close,

						["<CR>"] = actions.select_default,
						["<C-->"] = actions.select_horizontal,
						["<C-\\>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,

						["<C-u>"] = actions.results_scrolling_up,
						["<C-d>"] = actions.results_scrolling_down,

						["<C-b>"] = actions.preview_scrolling_up,
						["<C-f>"] = actions.preview_scrolling_down,
					},

					n = {
						["j"] = actions.move_selection_next,
						["k"] = actions.move_selection_previous,
						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["H"] = actions.move_to_top,
						["M"] = actions.move_to_middle,
						["L"] = actions.move_to_bottom,
						["gg"] = actions.move_to_top,
						["G"] = actions.move_to_bottom,

						["<C-e>"] = actions.close,
						["<Esc>"] = actions.close,
						["q"] = actions.close,

						["<CR>"] = actions.select_default,
						["<C-->"] = actions.select_horizontal,
						["<C-\\>"] = actions.select_vertical,
						["<C-t>"] = actions.select_tab,

						["<C-p>"] = layout.toggle_preview,

						["<C-u>"] = actions.results_scrolling_up,
						["<C-d>"] = actions.results_scrolling_down,

						["<C-b>"] = actions.preview_scrolling_up,
						["<C-f>"] = actions.preview_scrolling_down,

						["?"] = actions.which_key,
					},
				},
			}),
			pickers = {
				buffers = {
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
				git_branches = {
					theme = "ivy",
				},
				git_commits = {
					theme = "ivy",
				},
				git_bcommits = {
					theme = "ivy",
				},
				lsp_definitions = {
					path_display = { "tail" },
				},
				lsp_implementations = {
					path_display = { "tail" },
				},
				lsp_references = {
					path_display = { "tail" },
				},
			},
		})
		require("telescope").load_extension("notify")
	end,
	cmd = "Telescope",
	keys = {
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffer" },
		{ "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Find Colorscheme" },
		{ "<leader>fC", "<cmd>Telescope commands()<cr>", desc = "Find Commands" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find Help" },
		{ "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Find Keymaps" },
		{ "<leader>fl", "<cmd>Telescope resume<cr>", desc = "Find Last Search" },
		{ "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Find Man Pages" },
		{ "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Find Notify" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find Recent File" },
		{ "<leader>fR", "<cmd>Telescope registers<cr>", desc = "Find Registers" },
		{ "<leader>ft", "<cmd>Telescope live_grep<cr>", desc = "Find Text" },
		{ "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "List branch" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "List Commit" },
		{ "<leader>gC", "<cmd>Telescope git_bcommits<cr>", desc = "List Buffer Commit" },
		{ "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
		{ "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
	},
}
