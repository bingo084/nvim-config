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
			{ "<leader>tb", function() _BTOP_TOGGLE() end, desc = "Open Btop" },
			{ "<leader>td", function() _LAZYDOCKER_TOGGLE() end, desc = "Open Lazydocker" },
			{ "<leader>tf", "<cmd>Lazy load telescope.nvim<Bar>TermSelect<CR>", desc = "[T]erm [F]ind" },
		},
	},
	{
		"mrjones2014/smart-splits.nvim",
		build = "./kitty/install-kittens.bash",
		---@type SmartSplitsConfig
		opts = { ---@diagnostic disable-line:missing-fields
			default_amount = 2,
			at_edge = "split",
		},
		event = "VeryLazy",
		keys = function()
			local function ss() return require("smart-splits") end
			local mode = { "n", "i", "t" }
			return {
				{ "<A-h>", function() ss().move_cursor_left() end, mode = mode, desc = "Move to left window" },
				{ "<A-j>", function() ss().move_cursor_down() end, mode = mode, desc = "Move to down window" },
				{ "<A-k>", function() ss().move_cursor_up() end, mode = mode, desc = "Move to up window" },
				{ "<A-l>", function() ss().move_cursor_right() end, mode = mode, desc = "Move to right window" },
				{ "<A-S-h>", function() ss().swap_buf_left() end, mode = mode, desc = "Swap window left" },
				{ "<A-S-j>", function() ss().swap_buf_down() end, mode = mode, desc = "Swap window down" },
				{ "<A-S-k>", function() ss().swap_buf_up() end, mode = mode, desc = "Swap window up" },
				{ "<A-S-l>", function() ss().swap_buf_right() end, mode = mode, desc = "Swap window right" },
				{ "<A-r>", function() ss().start_resize_mode() end, mode = mode, desc = "Start Resize window mode" },
				{ "<A-w>", "<cmd>close<cr>", mode = mode, desc = "Close window" },
			}
		end,
	},
}
