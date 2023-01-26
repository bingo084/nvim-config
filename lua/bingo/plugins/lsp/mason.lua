local servers = {
	"jdtls",
	"jsonls",
	"sumneko_lua",
	"yamlls",
	"bashls",
}

return {
	{
		"williamboman/mason.nvim",
		config = true,
		keys = { { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer Info" } },
	},
	{
		"williamboman/mason-lspconfig.nvim",
		opts = { ensure_installed = servers },
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local handlers = require("bingo.plugins.lsp.handlers")
			local opts = {}
			handlers.setup()
			for _, server in pairs(servers) do
				opts = {
					on_attach = handlers.on_attach,
					capabilities = handlers.capabilities,
				}

				server = vim.split(server, "@")[1]

				if server == "jsonls" then
					local jsonls_opts = require("bingo.plugins.lsp.settings.jsonls")
					opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
				end

				if server == "yamlls" then
					local yamlls_opts = require("bingo.plugins.lsp.settings.yamlls")
					opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
				end

				if server == "sumneko_lua" then
					local sumneko_opts = require("bingo.plugins.lsp.settings.sumneko_lua")
					opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
				end

				if server == "jdtls" then
					goto continue
				end

				require("lspconfig")[server].setup(opts)
				::continue::
			end
		end,
		keys = {
			i = { "<cmd>LspInfo<cr>", "Info" },
		},
	},
	{ "b0o/SchemaStore.nvim", lazy = true },
}
