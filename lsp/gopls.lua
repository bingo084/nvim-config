return {
	settings = {
		-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
		gopls = {
			codelenses = {
				test = true,
			},
			gofumpt = true,
			hints = {
				compositeLiteralFields = true,
				constantValues = true,
				functionTypeParameters = true,
				ignoredError = true,
				parameterNames = true,
			},
			staticcheck = true,
		},
	},
}
