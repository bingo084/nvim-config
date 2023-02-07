return {
	"jose-elias-alvarez/null-ls.nvim",
	opts = function()
		local formatting = require("null-ls").builtins.formatting
		local diagnostics = require("null-ls").builtins.diagnostics
		return {
			sources = {
				formatting.stylua,
				formatting.google_java_format,
				formatting.yamlfmt,
				formatting.shfmt,
				formatting.markdownlint,
				diagnostics.markdownlint,
			},
		}
	end,
	keys = {
		{ "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", desc = "Format" },
		{
			"<leader>lF",
			"<cmd>lua require('bingo.plugins.lsp.handlers').toggle_format_on_save()<cr>",
			desc = "Toggle Autoformat",
		},
	},
	event = "LspAttach",
}
