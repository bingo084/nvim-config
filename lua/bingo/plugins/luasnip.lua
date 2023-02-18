return {
	"L3MON4D3/LuaSnip",
	config = function()
		local types = require("luasnip.util.types")

		require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })

		require("luasnip").setup({
			history = true,
			update_events = "TextChanged,TextChangedI",
			region_check_events = "CursorMoved",
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "", "DiagnosticHint" } },
					},
				},
				[types.insertNode] = {
					active = {
						virt_text = { { "", "DiagnosticHint" } },
					},
				},
			},
		})

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = { "*/snippets/*.lua" },
			callback = function()
				vim.keymap.set("n", "<CR>", ":/local snippets = {<CR>:nohlsearch<CR>f{%O", { buffer = 0 })
				vim.keymap.set("n", "<S-CR>", ":/local autosnippets = {<CR>:nohlsearch<CR>f{%O", { buffer = 0 })
			end,
		})
	end,
	keys = {
		{
			"<C-j>",
			function()
				return require("luasnip").expand_or_jumpable() and [[<cmd>lua require("luasnip").expand_or_jump()<CR>]]
					or "<C-j>"
			end,
			mode = { "i", "s" },
			expr = true,
		},
		{
			"<C-k>",
			function()
				return require("luasnip").jumpable(-1) and [[<cmd>lua require("luasnip").jump(-1)<CR>]] or "<C-k>"
			end,
			mode = { "i", "s" },
			expr = true,
		},
		{
			"<C-l>",
			function()
				return require("luasnip").choice_active() and [[<cmd>lua require("luasnip").change_choice(1)<CR>]]
					or "<C-l>"
			end,
			mode = { "i", "s" },
			expr = true,
		},
		{
			"<C-h>",
			function()
				return require("luasnip").choice_active() and [[<cmd>lua require("luasnip.extras.select_choice")()<CR>]]
					or "<C-h>"
			end,
			mode = { "i", "s" },
			expr = true,
		},
		{
			"<leader>se",
			[[<cmd>lua require("luasnip.loaders.from_lua").edit_snippet_files()<CR>]],
			desc = "Snip Edit",
		},
	},
}
