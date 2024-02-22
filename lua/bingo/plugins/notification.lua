return {
	{
		"rcarriga/nvim-notify",
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				fps = 144,
				timeout = 3000,
			})
		end,
		keys = {
			{ "<leader>nc", "<cmd>lua require('notify').dismiss()<cr>", desc = "Notification Clear" },
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
}
