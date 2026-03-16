---@type LazySpec
return {
	{
		"kevinhwang91/nvim-fundo",
		dependencies = { "kevinhwang91/promise-async" },
		build = function() require("fundo").install() end,
		opts = {},
		event = "BufReadPre",
	},
	{
		"XXiaoA/atone.nvim",
		opts = {},
		keys = {
			{ "<leader>u", function() require("atone.core").toggle() end, desc = "Toggle Undo Tree" },
		},
	},
}
