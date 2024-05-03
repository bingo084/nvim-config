return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				direction = "float",
				float_opts = {
					border = "curved",
				},
			})

			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({ cmd = "lazygit" })
			local btop = Terminal:new({ cmd = "btop" })
			local lazydocker = Terminal:new({ cmd = "lazydocker" })
			local float_term = Terminal:new({ direction = "float" })
			local vertical_term = Terminal:new({ direction = "vertical" })
			local horizontal_term = Terminal:new({ direction = "horizontal" })

			function _LAZYGIT_TOGGLE() lazygit:toggle() end
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
			{ "<leader>tb", function() _BTOP_TOGGLE() end, desc = "Open Btop" },
			{ "<leader>td", function() _LAZYDOCKER_TOGGLE() end, desc = "Open Lazydocker" },
			{ "<leader>tf", "<cmd>Lazy load telescope.nvim<Bar>TermSelect<CR>", desc = "[T]erm [F]ind" },
			{ "<leader>tg", function() _LAZYGIT_TOGGLE() end, desc = "Open Lazygit" },
			{ "<leader>gg", function() _LAZYGIT_TOGGLE() end, desc = "Open Lazygit" },
		},
	},
	{
		"knubie/vim-kitty-navigator",
		init = function() vim.g.kitty_navigator_no_mappings = 1 end,
		build = "cp ./*.py ~/.config/kitty/",
		cmd = { "KittyNavigateLeft", "KittyNavigateDown", "KittyNavigateUp", "KittyNavigateRight" },
	},
}
