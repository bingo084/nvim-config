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
				if require("luasnip").expand_or_jumpable() then
					require("luasnip").expand_or_jump()
				end
			end,
			mode = { "i", "s" },
		},
		{
			"<C-k>",
			function()
				if require("luasnip").jumpable(-1) then
					require("luasnip").jump(-1)
				end
			end,
			mode = { "i", "s" },
		},
		{
			"<C-l>",
			function()
				if require("luasnip").choice_active() then
					require("luasnip").change_choice(1)
				end
			end,
			mode = { "i", "s" },
		},
		{
			"<C-h>",
			function()
				if require("luasnip").choice_active() then
					require("luasnip.extras.select_choice")()
				end
			end,
			mode = { "i", "s" },
		},
		{
			"<leader>se",
			[[<cmd>lua require("luasnip.loaders.from_lua").edit_snippet_files()<cr>]],
			desc = "Snip Edit",
		},
	},
}
