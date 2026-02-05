local function ps() return require("persisted") end
return {
	"olimorris/persisted.nvim",
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			group = vim.api.nvim_create_augroup("PersistedLoadPreFocus", {}),
			pattern = "PersistedLoadPre",
			callback = function()
				local function is_float(win_id)
					return vim.wo[win_id].winfixwidth
						or vim.wo[win_id].winfixheight
						or vim.api.nvim_win_get_config(win_id).zindex
				end
				if is_float() then
					vim.iter(vim.api.nvim_tabpage_list_wins(0))
						:filter(function(win) return not (is_float(win)) end)
						:take(1)
						:each(function(win) vim.api.nvim_set_current_win(win) end)
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
