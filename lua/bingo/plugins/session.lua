local function ps() return require("persisted") end
return {
	"olimorris/persisted.nvim",
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = "PersistedTelescopeLoadPre",
			group = vim.api.nvim_create_augroup("PersistedHooks", {}),
			callback = function()
				require("persisted").save({ session = vim.g.persisted_loaded_session })
				vim.cmd("wall")
				vim.cmd("%bdelete!")
			end,
		})
	end,
	opts = {
		silent = false,
		use_git_branch = true,
		autoload = true,
		ignored_dirs = { { os.getenv("HOME"), exact = true } },
	},
	keys = {
		{ "<leader>fs", "<cmd>Telescope persisted<cr>", desc = "[F]ind [S]ession" },
		{ "<leader>sd", function() ps().delete() end, desc = "[S]ession [D]elete" },
		{ "<leader>sl", function() ps().load() end, desc = "[S]ession [L]oad" },
		{ "<leader>ss", function() ps().save() end, desc = "[S]ession [S]ave" },
	},
}
