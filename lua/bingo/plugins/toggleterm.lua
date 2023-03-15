return {
	"akinsho/toggleterm.nvim",
	config = function()
		require("toggleterm").setup({
			shade_terminals = true,
			shading_factor = -10,
			start_in_insert = true,
			direction = "float",
			float_opts = {
				border = "curved",
			},
		})

		function _G.set_terminal_keymaps()
			local opts = { noremap = true, buffer = 0 }
			vim.keymap.set({ "n", "t" }, "<esc>", "<cmd>exit<CR>", opts)
			vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

		local Terminal = require("toggleterm.terminal").Terminal
		local unmap_key = function(term)
			if vim.fn.mapcheck("jk", "t") ~= "" then
				vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
				vim.keymap.del("t", "jk", { buffer = term.bufnr })
			end
		end

		local lazygit = Terminal:new({ cmd = "lazygit", on_open = unmap_key, hidden = true })
		function _LAZYGIT_TOGGLE()
			lazygit:toggle()
		end

		local btop = Terminal:new({ cmd = "btop", on_open = unmap_key, hidden = true })
		function _BTOP_TOGGLE()
			btop:toggle()
		end

		local lazydocker = Terminal:new({ cmd = "lazydocker", on_open = unmap_key, hidden = true })
		function _LAZYDOCKER_TOGGLE()
			lazydocker:toggle()
		end

		local float_term = Terminal:new({
			direction = "float",
			on_open = function(term)
				vim.keymap.set(
					{ "n", "i", "t" },
					"<c-\\>",
					"<cmd>exit<CR><cmd>lua _VERTICAL_TERM()<CR>",
					{ silent = true, buffer = term.bufnr }
				)
				vim.keymap.set(
					{ "n", "i", "t" },
					"<c-->",
					"<cmd>exit<CR><cmd>lua _HORIZONTAL_TERM()<CR>",
					{ silent = true, buffer = term.bufnr }
				)
			end,
			count = 1,
		})

		function _FLOAT_TERM()
			float_term:toggle()
		end

		local vertical_term = Terminal:new({
			direction = "vertical",
			on_open = function(term)
				vim.keymap.set(
					{ "n", "i", "t" },
					"<c-->",
					"<cmd>exit<CR><cmd>lua _HORIZONTAL_TERM()<CR>",
					{ silent = true, buffer = term.bufnr }
				)
			end,
			count = 2,
		})

		function _VERTICAL_TERM()
			vertical_term:toggle(60)
		end

		local horizontal_term = Terminal:new({
			direction = "horizontal",
			on_open = function(term)
				vim.keymap.set(
					{ "n", "i", "t" },
					"<c-\\>",
					"<cmd>exit<CR><cmd>lua _VERTICAL_TERM()<CR>",
					{ silent = true, buffer = term.bufnr }
				)
			end,
			count = 3,
		})

		function _HORIZONTAL_TERM()
			horizontal_term:toggle(10)
		end
	end,
	keys = {
		{ "<c-=>", "<cmd>lua _FLOAT_TERM()<cr>", mode = { "n", "i", "t" }, desc = "Open Float Term" },
		{ "<c-->", "<cmd>lua _HORIZONTAL_TERM()<cr>", mode = { "n", "i", "t" }, desc = "Open Horizontal Term" },
		{ "<c-\\>", "<cmd>lua _VERTICAL_TERM()<cr>", mode = { "n", "i", "t" }, desc = "Open Vertical Term" },
		{ "<leader>t1", ":1ToggleTerm<cr>", desc = "Open Term1" },
		{ "<leader>t2", ":2ToggleTerm<cr>", desc = "Open Term2" },
		{ "<leader>t3", ":3ToggleTerm<cr>", desc = "Open Term3" },
		{ "<leader>t4", ":4ToggleTerm<cr>", desc = "Open Term4" },
		{ "<leader>tb", "<cmd>lua _BTOP_TOGGLE()<cr>", desc = "Open Btop" },
		{ "<leader>td", "<cmd>lua _LAZYDOCKER_TOGGLE()<cr>", desc = "Open Lazydocker" },
		{ "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "Open Lazygit" },
		{ "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<cr>", desc = "Open Lazygit" },
	},
}
