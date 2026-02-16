local function ps() return require("persisted") end
return {
	"olimorris/persisted.nvim",
	lazy = false,
	init = function()
		local lazy_win = nil
		local group = vim.api.nvim_create_augroup("PersistedHooks", {})
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "PersistedLoadPre",
			callback = function()
				if vim.bo.filetype == "lazy" then
					vim.api.nvim_win_close(0, false)
					lazy_win = true
				end
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "PersistedLoadPost",
			callback = function()
				if lazy_win then
					require("lazy").install()
				end
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
		{ "<leader>sd", function() ps().delete_current() end, desc = "Delete" },
		{ "<leader>sD", function() ps().delete() end, desc = "Delete" },
		{ "<leader>fS", function() ps().select() end, desc = "Session" },
		{ "<leader>sl", function() ps().load() end, desc = "Load" },
		{ "<leader>ss", function() ps().save() end, desc = "Save" },
	},
}
