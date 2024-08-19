local function map(mode, key, action, desc)
	local opts = { desc = desc }
	vim.keymap.set(mode, key, action, opts)
end
-- Remap space as leader key
vim.g.mapleader = " "
map("", "<Space>", "<Nop>", "Leader Key")
-- Clear hlight search
map("n", "<Esc>", "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-l><CR>", "Clear Highlight")
map("i", "<S-CR>", "<Esc>o", "New Line")
-- Press jk fast to enter
map("i", "jk", "<ESC>", "Esc")
-- Easier move header and tail
map("n", "<S-h>", "^", "Goto Line Head")
map("v", "<S-h>", "^", "Goto Line Head")
map("n", "<S-l>", "$", "Goto Line End")
map("v", "<S-l>", "$", "Goto Line End")
-- Easier indent
map("v", ">", ">gv", "Increase indent")
map("v", "<", "<gv", "Decrease indent")
-- Move text up and down
map("v", "<C-A-j>", "<cmd>'<,'>m '>+1<CR>gv=gv", "Move Line Down")
map("v", "<C-A-k>", "<cmd>'<,'>m '<-2<CR>gv=gv", "Move Line Up")
map("n", "<C-A-j>", "<cmd>m .+1<CR>==", "Move Line Down")
map("n", "<C-A-k>", "<cmd>m .-2<CR>==", "Move Line Up")
map("i", "<C-A-j>", "<Esc><cmd>m .+1<CR>==gi", "Move Line Down")
map("i", "<C-A-k>", "<Esc><cmd>m .-2<CR>==gi", "Move Line Up")
-- Quit write and quit
map("n", "<leader>w", "<cmd>w<CR>", "Write")
map("n", "<leader>W", "<cmd>wall<CR>", "Write All")
map("n", "<leader>q", "<cmd>qall<CR>", "Quit all")
map("n", "<leader>Q", "<cmd>qall!<CR>", "Quit all force")
-- Quickfix
map("n", "]q", "<cmd>cnext<CR>", "Next [Q]uickfix")
map("n", "[q", "<cmd>cprev<CR>", "Prev [Q]uickfix")
map("n", "]Q", "<cmd>clast<CR>", "Last [Q]uickfix")
map("n", "[Q", "<cmd>cfirst<CR>", "First [Q]uickfix")
-- Loclist
map("n", "]l", "<cmd>lnext<CR>", "Next [L]oclist")
map("n", "[l", "<cmd>lprev<CR>", "Prev [L]oclist")
map("n", "]L", "<cmd>llast<CR>", "Last [L]oclist")
map("n", "[L", "<cmd>lfirst<CR>", "First [L]oclist")
-- Toggle some options
local function toggle(opt, val)
	return function() require("bingo.utils").toggle_option(opt, val) end
end
map("n", "<leader>ow", toggle("wrap"), "Toggle Wrap")
map("n", "<leader>or", toggle("relativenumber"), "Toggle Relative Number")
map("n", "<leader>ol", toggle("cursorline"), "Toggle Cursorline")
map("n", "<leader>os", toggle("spell"), "Toggle Spell")
map("n", "<leader>ot", toggle("showtabline", { 0, 2 }), "Toggle Tabline")
