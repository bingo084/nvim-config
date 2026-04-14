---@type vim.lsp.Config
return {
	---@module "lspconfig"
	---@type lspconfig.settings.lua_ls
	settings = {
		-- https://luals.github.io/wiki/settings/
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			format = {
				enable = false,
			},
			hint = {
				arrayIndex = "Disable",
				awaitPropagate = true,
				semicolon = "SameLine",
			},
		},
	},
}
