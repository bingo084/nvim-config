return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "folke/neodev.nvim", opts = {} },
			{ "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
			{
				"williamboman/mason.nvim",
				config = true,
				keys = { { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer Info" } },
			},
		},
		lazy = false,
		config = function()
			local servers = {
				bashls = {},
				jsonls = { settings = { json = { schemas = require("schemastore").json.schemas() } } },
				lua_ls = {
					settings = { Lua = { completion = { callSnippet = "Replace" }, format = { enable = false } } },
				},
				yamlls = {},
				rust_analyzer = {},
			}
			local handlers = require("bingo.plugins.lsp.handlers")
			handlers.setup()
			for _, lsp in ipairs(vim.tbl_keys(servers)) do
				servers[lsp]["on_attach"] = handlers.on_attach
				servers[lsp]["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
				require("lspconfig")[lsp].setup(servers[lsp])
			end
		end,
		keys = { { "<leader>li", "<cmd>LspInfo<CR>", desc = "Info" } },
	},
	{ "b0o/SchemaStore.nvim", lazy = true },
	{ "mfussenegger/nvim-jdtls", lazy = true },
	{
		"nvimtools/none-ls.nvim",
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
			{ "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "[F]ormat" },
			{
				"<leader>lF",
				function() require("bingo.plugins.lsp.handlers").toggle_format_on_save() end,
				desc = "Toggle Autoformat",
			},
			{ "]d", function() vim.diagnostic.goto_next() end, desc = "Next [D]iagnostic" },
			{ "[d", function() vim.diagnostic.goto_prev() end, desc = "Prev [D]iagnostic" },
			{ "<leader>lq", function() vim.diagnostic.setloclist() end, desc = "Quickfix" },
		},
		event = "LspAttach",
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = "LspAttach",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		opts = { automatic_installation = true },
	},
}
