---@type LazySpec[]
return {
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim" },
		event = "VeryLazy",
		opts = {
			notify = { enabled = false },
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = { long_message_to_split = true, inc_rename = true, lsp_doc_border = true },
			views = { popup = { size = { width = 0.5, height = 0.3 } } },
		},
		keys = {
			{
				"<S-Enter>",
				function() require("noice").redirect(vim.fn.getcmdline()) end,
				mode = "c",
				desc = "Redirect Cmdline",
			},
		},
	},
	{
		"smjonas/inc-rename.nvim",
		opts = {},
		keys = { { "<leader>lr", ":IncRename <C-r><C-w>", desc = "Rename" } },
	},
}
