return {
	{
		"alker0/chezmoi.vim",
		cond = function() return vim.fn.expand("%:p"):match("chezmoi") ~= nil end,
		config = function() vim.g["chezmoi#use_tmp_buffer"] = true end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup(
				{ "*" },
				{ RRGGBBAA = true, rgb_fn = true, hsl_fn = true, css = true, css_fn = true }
			)
		end,
		ft = { "css" },
		keys = {
			{ "<leader>oc", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer" },
		},
	},
	{
		"numToStr/Comment.nvim",
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
		},
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			})
		end,
		keys = {
			{ "gc", mode = { "n", "v" } },
			{ "gb", mode = { "n", "v" } },
		},
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			require("illuminate").configure({
				modes_denylist = { "v" },
				large_file_cutoff = 5000,
			})
		end,
		event = "VeryLazy",
		keys = {
			{ "<leader>oh", function() require("illuminate").toggle() end, desc = "Toggle Doc HL" },
		},
	},
}
