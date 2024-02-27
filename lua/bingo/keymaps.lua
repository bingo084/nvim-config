local map = require("bingo.functions").map
-- remap space as leader key
vim.g.mapleader = " "
map("", "<Space>", "<Nop>", "Leader Key")
-- clear hlight search
map("n", "<Esc><Esc>", "<cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-l><CR>", "Clear Highlight")
map("i", "<S-CR>", "<Esc>o", "New Line")
-- Resize with arrows
map("n", "<C-Up>", "<cmd>resize +2<CR>", "Resize Window Higher")
map("n", "<C-Down>", "<cmd>resize -2<CR>", "Resize Window Lower")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Resize Window Thinner")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Resize Window Wider")
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
-- Paste without replace clipboard
map("v", "p", '"_dP', "Paste")
-- Move text up and down
map("v", "<C-A-j>", ":m '>+1<CR>gv=gv", "Move Line Down")
map("v", "<C-A-k>", ":m '<-2<CR>gv=gv", "Move Line Up")
map("n", "<C-A-j>", "<cmd>m .+1<CR>==", "Move Line Down")
map("n", "<C-A-k>", "<cmd>m .-2<CR>==", "Move Line Up")
map("i", "<C-A-j>", "<Esc><cmd>m .+1<CR>==gi", "Move Line Down")
map("i", "<C-A-k>", "<Esc><cmd>m .-2<CR>==gi", "Move Line Up")
-- Easier wincmd
map({ "n", "i", "t" }, "<A-h>", "<cmd>wincmd h<CR>", "Move to left window")
map({ "n", "i", "t" }, "<A-j>", "<cmd>wincmd j<CR>", "Move to down window")
map({ "n", "i", "t" }, "<A-k>", "<cmd>wincmd k<CR>", "Move to up window")
map({ "n", "i", "t" }, "<A-l>", "<cmd>wincmd l<CR>", "Move to right window")
map({ "n", "i", "t" }, "<A-c>", "<cmd>wincmd c<CR>", "Close current window")
-- Split window
map("n", "<leader>\\", "<cmd>vsplit<cr>", "Vsplit")
map("n", "<leader>-", "<cmd>split<cr>", "Split")
-- Quit write and quit
map("n", "<leader>w", "<cmd>w<CR>", "Write")
map("n", "<leader>W", "<cmd>wall<CR>", "Write All")
map("n", "<leader>q", "<cmd>qall<CR>", "Quit")
map("n", "<leader>Q", "<cmd>qall!<CR>", "Quit")
-- Toggle some options
map("n", "<leader>ow", '<cmd>lua require("bingo.functions").toggle_option("wrap")<cr>', "Toggle Wrap")
map(
	"n",
	"<leader>or",
	'<cmd>lua require("bingo.functions").toggle_option("relativenumber")<cr>',
	"Toggle Relative Number"
)
map("n", "<leader>ol", '<cmd>lua require("bingo.functions").toggle_option("cursorline")<cr>', "Toggle Cursorline")
map("n", "<leader>os", '<cmd>lua require("bingo.functions").toggle_option("spell")<cr>', "Toggle Spell")
map("n", "<leader>ot", '<cmd>lua require("bingo.functions").toggle_tabline()<cr>', "Toggle Tabline")
