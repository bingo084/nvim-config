local servers = {
	"jdtls",
	"jsonls",
	"lua_ls",
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
		commit = "1a2d5f5",
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

				if server == "lua_ls" then
					local lua_ls_opts = require("bingo.plugins.lsp.settings.lua_ls")
					opts = vim.tbl_deep_extend("force", lua_ls_opts, opts)
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
