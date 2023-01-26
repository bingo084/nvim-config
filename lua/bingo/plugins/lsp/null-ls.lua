return {
	"jose-elias-alvarez/null-ls.nvim",
	opts = function()
		local formatting = require("null-ls").builtins.formatting
		return {
			sources = {
				formatting.stylua,
				formatting.google_java_format,
				formatting.yamlfmt,
				formatting.shfmt,
			},
		}
	end,
	event = "LspAttach",
}
