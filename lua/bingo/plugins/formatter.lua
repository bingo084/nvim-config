---@type LazySpec
return {
	{
		"stevearc/conform.nvim",
		---@module "conform"
		---@type conform.setupOpts
		opts = {
			formatters_by_ft = {
				go = { "goimports", lsp_format = "last" },
				lua = { "stylua" },
				java = { "google-java-format" },
				yaml = { "yamlfmt" },
				sh = { "shfmt" },
				markdown = { "markdownlint" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				sql = { "sql_formatter" },
			},
			formatters = {
				sql_formatter = {
					prepend_args = function(_, ctx)
						local first_line = vim.api.nvim_buf_get_lines(ctx.buf, 0, 1, false)[1] or ""
						local language = first_line:match("%-%-%s*dialect%s*:%s*(%w+)")
						return language and { "--language", language } or {}
					end,
				},
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
		},
		keys = {
			{
				"<leader>lf",
				function() require("conform").format({ async = true }) end,
				mode = { "n", "v" },
				desc = "Format",
			},
		},
	},
	{
		"zapling/mason-conform.nvim",
		config = true,
		event = "VeryLazy",
	},
}
