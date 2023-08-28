return {
	"numToStr/Comment.nvim",
    config = function()
		require("Comment").setup({
			pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
		})
	end,
	keys = {
		{ "gc", mode = { "n", "v" } },
		{ "gb", mode = { "n", "v" } },
		{ "<leader>/", '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', desc = "Comment" },
		{
			"<leader>/",
			'<esc><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<cr>',
			desc = "Comment",
			mode = "v",
		},
	},
}
