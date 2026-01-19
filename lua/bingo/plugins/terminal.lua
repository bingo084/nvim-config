---@type LazySpec
return {
	{
		"akinsho/toggleterm.nvim",
		version = false,
		config = function()
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = "curved",
				},
			})

			local Terminal = require("toggleterm.terminal").Terminal
			local btop = Terminal:new({ cmd = "btop" })
			local lazydocker = Terminal:new({ cmd = "lazydocker" })
			local float_term = Terminal:new({ direction = "float" })
			local vertical_term = Terminal:new({ direction = "vertical" })
			local horizontal_term = Terminal:new({ direction = "horizontal" })

			function _BTOP_TOGGLE() btop:toggle() end
			function _LAZYDOCKER_TOGGLE() lazydocker:toggle() end
			function _FLOAT_TERM() float_term:toggle() end
			function _VERTICAL_TERM() vertical_term:open(60) end
			function _HORIZONTAL_TERM() horizontal_term:open(15) end
		end,
		keys = {
			{ "<c-=>", function() _FLOAT_TERM() end, mode = { "n", "i", "t" }, desc = "Open Float Term" },
			{ "<c-->", function() _HORIZONTAL_TERM() end, mode = { "n", "i", "t" }, desc = "Open Horizontal Term" },
			{ [[<c-\>]], function() _VERTICAL_TERM() end, mode = { "n", "i", "t" }, desc = "Open Vertical Term" },
			{ "<leader>tb", function() _BTOP_TOGGLE() end, desc = "Btop" },
			{ "<leader>td", function() _LAZYDOCKER_TOGGLE() end, desc = "Lazydocker" },
			{ "<leader>fT", "<cmd>TermSelect<CR>", desc = "Terminal" },
		},
	},
}
