return {
	{
		"ahmedkhalf/project.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern" },
			})
			require("telescope").load_extension("projects")
		end,
		keys = {
			{ "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Find Projects" },
		},
	},
	{
		"rmagatti/session-lens",
		dependencies = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
		config = function()
			require("session-lens").setup({
				prompt_title = "Sessions",
			})
			require("telescope").load_extension("session-lens")
		end,
	    cmd = "SearchSession",
		keys = {
			{ "<leader>fs", "<cmd>Telescope session-lens search_session<cr>", desc = "Find Sessions" },
		},
	},
	{
		"ziontee113/icon-picker.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			disable_legacy_commands = true,
		},
		keys = {
			{ "<leader>fi", "<cmd>IconPickerNormal<cr>", desc = "Find Icon" },
		},
	},
}
