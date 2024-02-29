return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			presets = {
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
			views = {
				popup = {
					size = {
						width = 0.5,
						height = 0.3,
					},
					win_options = {
						winblend = 8,
					},
				},
				hover = {
					win_options = {
						winblend = 8,
					},
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		keys = {
			{
				"<S-Enter>",
				function() require("noice").redirect(vim.fn.getcmdline()) end,
				desc = "Redirect Cmdline",
				mode = "c",
			},
			{ "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Notification Clear" },
		},
	},
	{
		"smjonas/inc-rename.nvim",
		opts = {},
		keys = {
			{ "<leader>lr", ":IncRename ", desc = "Rename" },
		},
	},
}
