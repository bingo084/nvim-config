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
				group = vim.api.nvim_create_augroup("nvim-lint", {}),
				callback = function(args)
					if vim.bo[args.buf].buftype == "" then
						require("lint").try_lint()
					end
				end,
				desc = "Lint on text change",
			})
		end,
		keys = {
			{ "<leader>ld", vim.diagnostic.open_float, desc = "Diagnostic" },
			{ "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, desc = "Next Diagnostic" },
			{ "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, desc = "Prev Diagnostic" },
			{ "<leader>ll", vim.diagnostic.setloclist, desc = "Loclist" },
			{ "<leader>lq", vim.diagnostic.setqflist, desc = "Qflist" },
		},
	},
	{
		"rshkarin/mason-nvim-lint",
		config = true,
		event = "VeryLazy",
	},
}
