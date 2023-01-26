local icons = require("bingo.icons")
return {
	"kyazdani42/nvim-tree.lua",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	opts = {
		hijack_directories = {
			enable = false,
		},
		ignore_ft_on_setup = {
			"alpha",
		},
		sync_root_with_cwd = true,
		renderer = {
			full_name = true,
			highlight_git = true,
			highlight_opened_files = "all",
			root_folder_label = ":t",
			indent_markers = {
				enable = true,
			},
		},
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			icons = {
				hint = icons.diagnostics.Hint,
				info = icons.diagnostics.Info,
				warning = icons.diagnostics.Warn,
				error = icons.diagnostics.Error,
			},
		},
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		view = {
			mappings = {
				list = {
					{ key = { "l", "<CR>", "o" }, action = "edit" },
					{ key = "h", action = "close_node" },
					{ key = "<leader>-", action = "split" },
					{ key = "<leader>\\", action = "vsplit" },
				},
			},
		},
		trash = {
			cmd = "trash",
		},
	},
	cmd = "NvimTreeOpen",
	keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" } },
}
