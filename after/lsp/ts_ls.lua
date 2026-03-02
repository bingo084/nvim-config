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
