return {
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
