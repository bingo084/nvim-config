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
		sync_root_with_cwd = true,
		renderer = {
			group_empty = true,
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
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
			api.config.mappings.default_on_attach(bufnr)
			vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
			vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
			vim.keymap.set("n", "o", api.node.open.edit, opts("Open"))
			vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
			vim.keymap.set("n", "<leader>-", api.node.open.horizontal, opts("Open: Horizontal Split"))
			vim.keymap.set("n", "<leader>\\", api.node.open.vertical, opts("Open: Vertical Split"))
		end,
		trash = {
			cmd = "trash",
		},
	},
	cmd = { "NvimTreeOpen", "NvimTreeClose" },
	keys = { { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" } },
}
