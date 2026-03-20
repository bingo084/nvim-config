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
		"esmuellert/codediff.nvim",
		cmd = "CodeDiff",
		opts = {
			diff = { compute_moves = true },
			explorer = { initial_focus = "modified" },
			history = { initial_focus = "modified" },
			keymaps = {
				explorer = { select = "o" },
				history = { select = "o" },
			},
		},
		keys = {
			{ "<leader>gd", "<cmd>CodeDiff<CR>", desc = "Diff View" },
			{ "<leader>gl", "<cmd>CodeDiff history<CR>", desc = "Log" },
			{ "<leader>gl", "<cmd>'<,'>CodeDiff history<CR>", mode = "x", desc = "Log Selection" },
			{ "<leader>gL", "<cmd>CodeDiff history %<CR>", desc = "Log Current File" },
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			preview_config = { border = "rounded" },
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				local function map(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end
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
		keys = function()
			local function nav_hunk(lhs, direction)
				return function()
					if vim.wo.diff then
						local count = vim.v.count > 0 and tostring(vim.v.count) or ""
						vim.cmd.normal({ count .. lhs, bang = true })
						return
					end
					if vim.b.gitsigns_status_dict == nil then
						return
					end
					---@diagnostic disable-next-line: missing-fields
					require("gitsigns").nav_hunk(direction, { count = vim.v.count1 })
				end
			end
			return {
				{ "]c", nav_hunk("]c", "next"), desc = "Next Change(hunk)" },
				{ "[c", nav_hunk("[c", "prev"), desc = "Prev Change(hunk)" },
			}
		end,
		event = "VeryLazy",
	},
}
