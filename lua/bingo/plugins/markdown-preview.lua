return {
	{
		"iamcco/markdown-preview.nvim",
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		ft = "markdown",
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown Preview" },
		},
	},
	{ "dhruvasagar/vim-table-mode", cmd = "TableModeEnable" },
}
