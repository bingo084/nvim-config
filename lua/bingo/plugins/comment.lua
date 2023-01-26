return {
	"numToStr/Comment.nvim",
	opts = {
		pre_hook = function(ctx)
			local U = require("Comment.utils")

			local location = nil
			if ctx.ctype == U.ctype.blockwise then
				location = require("ts_context_commentstring.utils").get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require("ts_context_commentstring.utils").get_visual_start_location()
			end

			return require("ts_context_commentstring.internal").calculate_commentstring({
				key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
				location = location,
			})
		end,
	},
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
