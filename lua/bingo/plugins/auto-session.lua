return {
	"rmagatti/auto-session",
	lazy = true,
    init = function()
        local autocmd = vim.api.nvim_create_autocmd

        local lazy_did_show_install_view = false

        local function auto_session_restore()
          -- important! without vim.schedule other necessary plugins might not load (eg treesitter) after restoring the session
          vim.schedule(function()
            require("auto-session").AutoRestoreSession()
          end)
        end

        autocmd("User", {
          pattern = "VeryLazy",
          callback = function()
            local lazy_view = require("lazy.view")

            if lazy_view.visible() then
              -- if lazy view is visible do nothing with auto-session
              lazy_did_show_install_view = true
            else
              -- otherwise load (by require'ing) and restore session
              auto_session_restore()
            end
          end,
        })

        autocmd("WinClosed", {
          pattern = "*",
          callback = function(ev)
            local lazy_view = require("lazy.view")

            -- if lazy view is currently visible and was shown at startup
            if lazy_view.visible() and lazy_did_show_install_view then
              -- if the window to be closed is actually the lazy view window
              if ev.match == tostring(lazy_view.view.win) then
                lazy_did_show_install_view = false
                auto_session_restore()
              end
            end
          end,
        })
    end,
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
		{ "<leader>sd", "<cmd>SessionDelete<cr>", desc = "Delete Session" },
		{ "<leader>sD", "<cmd>Autosession delete<cr>", desc = "Find Session and Delete" },
		{ "<leader>sr", "<cmd>SessionRestore<cr>", desc = "Restore Session" },
		{ "<leader>ss", "<cmd>SessionSave<cr>", desc = "Save Session" },
	},
}
