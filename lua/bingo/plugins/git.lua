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
		keys = {
			{ "<leader>gg", "<cmd>Git<CR>", desc = "Status" },
		},
	},
	{
		"sindrets/diffview.nvim",
		opts = function()
			vim.api.nvim_create_autocmd("BufWinEnter", {
				pattern = "diffview://*/log/*/commit_log",
				group = vim.api.nvim_create_augroup("diffview", {}),
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
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
			{ "<leader>gl", "<cmd>DiffviewFileHistory<CR>", desc = "Log" },
			{ "<leader>gL", "<cmd>DiffviewFileHistory %<CR>", desc = "Log Current File" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end
				local function navimap(lhs, rhs, desc)
					vim.keymap.set("n", lhs, function()
						if vim.wo.diff then
							return lhs
						end
						vim.schedule(rhs)
						return "<Ignore>"
					end, { buffer = bufnr, desc = desc, expr = true })
				end
				navimap("]c", gitsigns.next_hunk, "Next Change(hunk)")
				navimap("[c", gitsigns.prev_hunk, "Prev Change(hunk)")
				map("n", "<leader>gb", function() gitsigns.blame_line({ full = true }) end, "Blame")
				map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Hunk")
				map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Hunk")
				map("n", "<leader>gs", gitsigns.stage_hunk, "Toggle Stage Hunk")
				local range = { vim.fn.line("."), vim.fn.line("v") }
				map("v", "<leader>gr", function() gitsigns.reset_hunk(range) end, "Reset Hunk")
				map("v", "<leader>gs", function() gitsigns.stage_hunk(range) end, "Toggle Stage Hunk")
				map("n", "<leader>gR", gitsigns.reset_buffer, "Reset Buffer")
				map("n", "<leader>gS", gitsigns.stage_buffer, "Toggle Stage Buffer")
				-- Text object
				map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<CR>", "inner hunk")
			end,
		},
		event = "VeryLazy",
	},
}
