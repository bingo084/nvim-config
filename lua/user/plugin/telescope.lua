local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
	vim.notify("telescope is not found!")
	return
end

local layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local icons = require("user.icons")

telescope.setup({
	defaults = {
		prompt_prefix = " " .. icons.ui.Telescope .. " ",
		selection_caret = " ",
		path_display = { "smart" },
		file_ignore_patterns = {
			".git/",
			"target/",
			"docs/",
			"vendor/*",
			"%.lock",
			"__pycache__/*",
			"%.sqlite3",
			"%.ipynb",
			"node_modules/*",
			-- "%.jpg",
			-- "%.jpeg",
			-- "%.png",
			"%.svg",
			"%.otf",
			"%.ttf",
			"%.webp",
			".dart_tool/",
			".github/",
			".gradle/",
			".idea/",
			".settings/",
			".vscode/",
			"__pycache__/",
			"build/",
			"env/",
			"gradle/",
			"node_modules/",
			"%.pdb",
			"%.dll",
			"%.class",
			"%.exe",
			"%.cache",
			"%.ico",
			"%.pdf",
			"%.dylib",
			"%.jar",
			"%.docx",
			"%.met",
			"smalljre_*/*",
			".vale/",
			"%.burp",
			"%.mp4",
			"%.mkv",
			"%.rar",
			"%.zip",
			"%.7z",
			"%.tar",
			"%.bz2",
			"%.epub",
			"%.flac",
			"%.tar.gz",
		},

		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,
				["<Esc>"] = actions.close,

				["<CR>"] = actions.select_default,
				["<C-->"] = actions.select_horizontal,
				["<C-\\>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-p>"] = layout.toggle_preview,

				["<C-u>"] = actions.results_scrolling_up,
				["<C-d>"] = actions.results_scrolling_down,

				["K"] = actions.preview_scrolling_up,
				["J"] = actions.preview_scrolling_down,
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

				["<C-c>"] = actions.close,
				["<Esc>"] = actions.close,
				["q"] = actions.close,

				["<CR>"] = actions.select_default,
				["<C-->"] = actions.select_horizontal,
				["<C-\\>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-p>"] = layout.toggle_preview,

				["<C-u>"] = actions.results_scrolling_up,
				["<C-d>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
			},
		},
	},
	pickers = {
		buffers = {
			theme = "dropdown",
			previewer = false,
			initial_mode = "normal",
		},
		colorscheme = {
			theme = "cursor",
			enable_preview = true,
		},
		find_files = {
			theme = "dropdown",
			previewer = false,
		},
		help_tags = {
			theme = "dropdown",
		},
		live_grep = {
			theme = "dropdown",
		},
		grep_string = {
			theme = "dropdown",
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
			theme = "dropdown",
			path_display = { "tail" },
		},
		lsp_implementations = {
			theme = "dropdown",
			path_display = { "tail" },
		},
		lsp_references = {
			theme = "dropdown",
			path_display = { "tail" },
		},
	},
	extensions = {
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg" },
			find_cmd = "rg", -- find command (defaults to `fd`)
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
require("telescope").load_extension("ui-select")
