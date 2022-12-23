local mason_status_ok, mason = pcall(require, "mason")
if not mason_status_ok then
	vim.notify("mason is not found!")
	return
end
local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
	vim.notify("mason-lspconfig is not found!")
	return
end
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
	vim.notify("lspconfig is not found!")
	return
end

local servers = {
	"jdtls",
	"jsonls",
	"sumneko_lua",
	"yamlls",
	"bashls",
}

mason.setup()
mason_lspconfig.setup({
	ensure_installed = { "jdtls", "jsonls", "sumneko_lua", "yamlls", "bashls" },
})

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("user.plugin.lsp.handlers").on_attach,
		capabilities = require("user.plugin.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	if server == "jsonls" then
		local jsonls_opts = require("user.plugin.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server == "yamlls" then
		local yamlls_opts = require("user.plugin.lsp.settings.yamlls")
		opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
	end

	if server == "sumneko_lua" then
		local sumneko_opts = require("user.plugin.lsp.settings.sumneko_lua")
		opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
	end

	if server == "jdtls" then
		goto continue
	end

	lspconfig[server].setup(opts)
	::continue::
end
