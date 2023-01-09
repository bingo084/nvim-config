local ls = require("luasnip")
local types = require("luasnip.util.types")

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/user/snippets/" })

ls.setup({
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

vim.keymap.set({ "i", "s" }, "<C-j>", function()
	if ls.expand_or_jumpable() then
        ls.expand_or_jump()
	end
end)

vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    end
end)

vim.keymap.set({ "i", "s" }, "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

vim.keymap.set({ "i", "s" }, "<C-h>", function()
	if ls.choice_active() then
        require("luasnip.extras.select_choice")()
	end
end)

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*/snippets/*.lua" },
	callback = function()
		vim.keymap.set("n", "<CR>", ":/local snippets = {<CR>:nohlsearch<CR>f{%O", { buffer = 0 })
		vim.keymap.set("n", "<S-CR>", ":/local autosnippets = {<CR>:nohlsearch<CR>f{%O", { buffer = 0 })
	end,
})
