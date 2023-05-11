return {
	"rmagatti/auto-session",
	lazy = false,
	config = function()
		vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
		require("auto-session").setup({
			log_level = "info",
			auto_session_enable_last_session = false,
			auto_session_root_dir = vim.fn.stdpath("data") .. "/sessions/",
			auto_session_enabled = true,
			auto_save_enabled = nil,
			auto_restore_enabled = nil,
			auto_session_suppress_dirs = { os.getenv("HOME") },
			auto_session_use_git_branch = nil,
			-- the configs below are lua only
			bypass_session_save_file_types = { "alpha" },
			pre_save_cmds = { "NvimTreeClose" },
		})
	end,
	keys = {
		{ "<leader>sd", "<cmd>DeleteSession<cr>", desc = "Delete Session" },
		{ "<leader>sD", "<cmd>Autosession delete<cr>", desc = "Find Session and Delete" },
		{ "<leader>sr", "<cmd>RestoreSession<cr>", desc = "Restore Session" },
		{ "<leader>ss", "<cmd>SaveSession<cr>", desc = "Save Session" },
	},
}
