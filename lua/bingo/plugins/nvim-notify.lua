return {
	"rcarriga/nvim-notify",
	config = function()
		vim.notify = require("notify")
		require("notify").setup({
			fps = 144,
			top_down = false,
		})
	end,
}
