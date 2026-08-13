---@type vim.lsp.Config
return {
	init_options = {
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vim.uv.os_uname().sysname == "Linux" and "/usr"
					or "/opt/homebrew" .. "/lib/node_modules/@vue/typescript-plugin",
				languages = { "javascript", "typescript", "vue" },
			},
		},
		preferences = {
			preferTypeOnlyAutoImports = true,
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
}
