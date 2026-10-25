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
		-- Hide Codex only while serializing the editor layout; keep its job alive.
		local saved, focused = {}, nil
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "PersistedSavePre",
			callback = function()
				saved, focused = {}, vim.api.nvim_get_current_win()
				local Terminal = package.loaded["sidekick.cli.terminal"]
				for _, term in pairs(Terminal and Terminal.terminals or {}) do
					if term.tool.name == "codex" and term:is_open() then
						saved[#saved + 1] = { terminal = term, focused = term:is_focused() }
						term:hide()
					end
				end
			end,
		})
		vim.api.nvim_create_autocmd("User", {
			group = group,
			pattern = "PersistedSavePost",
			callback = function()
				local restore, previous = saved, focused
				saved, focused = {}, nil
				-- Restore terminal input after the session commands finish changing modes.
				vim.defer_fn(function()
					for _, entry in ipairs(restore) do
						entry.terminal:show()
						if entry.focused then
							entry.terminal:focus()
						end
					end
					if previous and vim.api.nvim_win_is_valid(previous) then
						vim.api.nvim_set_current_win(previous)
					end
				end, 0)
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
