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
				desc = "[F]ormat",
			},
		},
	},
	{
		"zapling/mason-conform.nvim",
		config = true,
		event = "VeryLazy",
	},
}
