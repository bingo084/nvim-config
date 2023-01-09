local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	vim.notify("toggleterm is not found!")
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
	},
})

function _G.set_terminal_keymaps()
	local opts = { noremap = true, buffer = 0 }
	vim.keymap.set({ "n", "t" }, "<esc>", "<cmd>exit<CR>", opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<c-h>", [[<C-\><C-n><C-W>h]], opts)
	vim.keymap.set("t", "<c-j>", [[<C-\><C-n><C-W>j]], opts)
	vim.keymap.set("t", "<c-k>", [[<C-\><C-n><C-W>k]], opts)
	vim.keymap.set("t", "<c-l>", [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

local Terminal = require("toggleterm.terminal").Terminal
local unmap_key = function(term)
	if vim.fn.mapcheck("jk", "t") ~= "" then
		vim.keymap.del("t", "<esc>", { buffer = term.bufnr })
		vim.keymap.del("t", "jk", { buffer = term.bufnr })
		vim.keymap.del("t", "<c-j>", { buffer = term.bufnr })
		vim.keymap.del("t", "<c-k>", { buffer = term.bufnr })
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

local float_term = Terminal:new({
	direction = "float",
	on_open = function(term)
		vim.keymap.set(
			{ "n", "i", "t" },
			"<c-2>",
			"<cmd>exit<CR><cmd>lua _VERTICAL_TERM()<CR>)",
			{ silent = true, buffer = term.bufnr }
		)
		vim.keymap.set(
			{ "n", "i", "t" },
			"<c-3>",
			"<cmd>exit<CR><cmd>lua _HORIZONTAL_TERM()<CR>)",
			{ silent = true, buffer = term.bufnr }
		)
	end,
	count = 1,
})

function _FLOAT_TERM()
	float_term:toggle()
end

vim.keymap.set({ "n", "i", "t" }, "<c-1>", _FLOAT_TERM, { silent = true })

local vertical_term = Terminal:new({
	direction = "vertical",
	on_open = function(term)
		vim.keymap.set(
			{ "n", "i", "t" },
			"<c-3>",
			"<cmd>exit<CR><cmd>lua _HORIZONTAL_TERM()<CR>)",
			{ silent = true, buffer = term.bufnr }
		)
	end,
	count = 2,
})

function _VERTICAL_TERM()
	vertical_term:toggle(60)
end

vim.keymap.set({ "n", "i", "t" }, "<c-2>", _VERTICAL_TERM, { silent = true })

local horizontal_term = Terminal:new({
	direction = "horizontal",
	on_open = function(term)
		vim.keymap.set(
			{ "n", "i", "t" },
			"<c-2>",
			"<cmd>exit<CR><cmd>lua _VERTICAL_TERM()<CR>",
			{ silent = true, buffer = term.bufnr }
		)
	end,
	count = 3,
})

function _HORIZONTAL_TERM()
	horizontal_term:toggle(10)
end

vim.keymap.set({ "n", "i", "t" }, "<c-3>", _HORIZONTAL_TERM, { silent = true })
