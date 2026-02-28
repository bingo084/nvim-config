return {
	settings = {
		-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
		gopls = {
			gofumpt = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				ignoredError = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			staticcheck = true,
		},
	},
}
