local opts = { noremap = true, silent = true }
-- shorten function name
local keymap = vim.keymap.set
-- remap space as leader key
vim.g.mapleader = " "
keymap("", "<Space>", "<Nop>", opts)
-- clear hlight search
keymap("n", "<CR>", "<cmd>nohlsearch<CR><CR>", opts)
keymap("i", "<S-CR>", "<Esc>o", opts)
-- tab
-- keymap('n', '<leader>c', '<cmd>tabc<CR>', opts)
-- keymap('n', '<leader>o', '<cmd>tabo<CR>', opts)
-- keymap('n', '<leader>j', 'gT', opts)
-- keymap('n', '<leader>k', 'gt', opts)
-- keymap('n', '<leader>1', '1gt', opts)
-- keymap('n', '<leader>2', '2gt', opts)
-- keymap('n', '<leader>3', '3gt', opts)
-- keymap('n', '<leader>4', '4gt', opts)
-- keymap('n', '<leader>5', '5gt', opts)
-- keymap('n', '<leader>6', '6gt', opts)
-- keymap('n', '<leader>7', '7gt', opts)
-- keymap('n', '<leader>8', '8gt', opts)
-- keymap('n', '<leader>9', '9gt', opts)
-- Better window navigation
keymap("n", "<C-h>", "<cmd>KittyNavigateLeft<cr>", opts)
keymap("n", "<C-j>", "<cmd>KittyNavigateDown<cr>", opts)
keymap("n", "<C-k>", "<cmd>KittyNavigateUp<cr>", opts)
keymap("n", "<C-l>", "<cmd>KittyNavigateRight<cr>", opts)
-- Resize with arrows
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", opts)
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", opts)
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)
-- Navigate buffers
keymap("n", "<leader>k", "K", opts)
keymap("n", "<leader>j", "J", opts)
keymap("n", "<S-k>", "<cmd>BufferLineCycleNext<CR>", opts)
keymap("n", "<S-j>", "<cmd>BufferLineCyclePrev<CR>", opts)
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
-- Easier move header and tail
keymap("n", "<S-h>", "^", opts)
keymap("v", "<S-h>", "^", opts)
keymap("n", "<S-l>", "$", opts)
keymap("v", "<S-l>", "$", opts)
-- Easier indent
keymap("v", ">", ">gv", opts)
keymap("v", "<", "<gv", opts)
-- Paste without replace clipboard
keymap("v", "p", '"_dP', opts)
-- Move text up and down
keymap("v", "<C-A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<C-A-k>", ":m '<-2<CR>gv=gv", opts)
keymap("n", "<C-A-j>", "<cmd>m .+1<CR>==", opts)
keymap("n", "<C-A-k>", "<cmd>m .-2<CR>==", opts)
keymap("i", "<C-A-j>", "<Esc><cmd>m .+1<CR>==gi", opts)
keymap("i", "<C-A-k>", "<Esc><cmd>m .-2<CR>==gi", opts)
