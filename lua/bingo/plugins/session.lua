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
		{ "<leader>sd", function() ps().delete() end, desc = "Delete" },
		{ "<leader>sl", function() ps().load() end, desc = "Load" },
		{ "<leader>ss", function() ps().save() end, desc = "Save" },
	},
}
