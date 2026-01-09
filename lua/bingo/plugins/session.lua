local function ps() return require("persisted") end
return {
	"olimorris/persisted.nvim",
	lazy = false,
	opts = {
		silent = false,
		use_git_branch = true,
		autoload = true,
		ignored_dirs = { { os.getenv("HOME"), exact = true } },
	},
	keys = {
		{ "<leader>sd", function() ps().delete() end, desc = "[S]ession [D]elete" },
		{ "<leader>sl", function() ps().load() end, desc = "[S]ession [L]oad" },
		{ "<leader>ss", function() ps().save() end, desc = "[S]ession [S]ave" },
	},
}
