---@type LazySpec
return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
		init = function()
			vim.g.db_ui_show_database_icon = 1
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_use_nvim_notify = 1
		end,
		cmd = {
			"DBUI",
			"DBUIToggle",
			"DBUIAddConnection",
			"DBUIFindBuffer",
		},
		keys = {
			{ "<leader>dd", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
		},
	},
}
