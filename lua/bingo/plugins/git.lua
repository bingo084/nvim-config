---@type LazySpec
return {
	{
		"tpope/vim-fugitive",
		version = false,
		cmd = {
			"G",
			"Git",
			"Ggrep",
			"Glgrep",
			"Gclog",
			"Gllog",
			"Gcd",
			"Glcd",
			"Gedit",
			"Gsplit",
			"Gvsplit",
			"Gtabedit",
			"Gpedit",
			"Gdrop",
			"Gread",
			"Gwrite",
			"Gwq",
			"Gdiffsplit",
			"Gvdiffsplit",
			"Ghdiffsplit",
			"Gmove",
			"GRename",
			"GDelete",
			"GRemove",
			"GUnlink",
			"GBrowse",
		},
	},
	{
		"sindrets/diffview.nvim",
		opts = function()
			vim.api.nvim_create_autocmd("BufWinEnter", {
				pattern = "diffview://*/log/*/commit_log",
				callback = function() vim.keymap.set("n", "q", "<cmd>q<CR>", { buffer = 0 }) end,
			})
			local actions = require("diffview.actions")
			---@type DiffviewConfig
			return {
				keymaps = {
					view = {
						{ "n", "q", actions.close, { desc = "Close view" } },
					},
					file_panel = {
						{ "n", "j", actions.select_next_entry, { desc = "Open the diff for the next file" } },
						{ "n", "down", actions.select_next_entry, { desc = "Open the diff for the next file" } },
						{ "n", "k", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
						{ "n", "<up>", actions.select_prev_entry, { desc = "Open the diff for the previous file" } },
						{ "n", "<A-d>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
						{ "n", "J", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
						{ "n", "<A-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
						{ "n", "K", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
						{ "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel" } },
						{ "n", "q", "<cmd>tabc<CR>", { desc = "Close tab" } },
					},
					file_history_panel = {
						{ "n", "d", actions.open_in_diffview, { desc = "Open selected entry in a diffview" } },
						{ "n", "<A-d>", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
						{ "n", "J", actions.scroll_view(0.25), { desc = "Scroll the view down" } },
						{ "n", "<A-u>", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
						{ "n", "K", actions.scroll_view(-0.25), { desc = "Scroll the view up" } },
						{ "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel" } },
						{ "n", "q", "<cmd>tabc<CR>", { desc = "Close tab" } },
					},
					option_panel = {
						{ "n", "<CR>", actions.select_entry, { desc = "Change the current option" } },
						{ "n", "o", actions.select_entry, { desc = "Change the current option" } },
					},
				},
			}
		end,
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "[D]iff view" },
			{ "<leader>gl", "<cmd>DiffviewFileHistory<CR>", desc = "[L]og" },
		},
	},
}
