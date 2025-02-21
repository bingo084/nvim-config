---@type LazySpec
return {
	{
		"mfussenegger/nvim-lint",
		config = function()
			require("lint").linters_by_ft = {
				markdown = { "markdownlint" },
			}
			require("lint").try_lint()
			vim.api.nvim_create_autocmd({ "BufReadPost", "TextChanged" }, {
				callback = function() require("lint").try_lint() end,
				group = vim.api.nvim_create_augroup("nvim-lint", {}),
				desc = "Lint on text change",
			})
		end,
		keys = {
			{ "<leader>ld", vim.diagnostic.open_float, desc = "[D]iagnostic" },
			{ "]d", vim.diagnostic.goto_next, desc = "Next [D]iagnostic" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Prev [D]iagnostic" },
			{ "<leader>ll", vim.diagnostic.setloclist, desc = "[L]oclist" },
			{ "<leader>lq", vim.diagnostic.setqflist, desc = "[Q]flist" },
		},
	},
	{
		"rshkarin/mason-nvim-lint",
		config = true,
		event = "VeryLazy",
	},
}
