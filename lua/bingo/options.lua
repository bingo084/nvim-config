local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.showmode = false
-- Sync clipboard between OS and Neovim.
opt.clipboard = "unnamedplus"
opt.breakindent = true
opt.smartindent = true
opt.wrap = false
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
-- Sets how neovim will display certain whitespace in the editor.
opt.list = true
opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }
-- Preview substitutions live, as you type!
opt.inccommand = "split"
opt.cursorline = true
opt.scrolloff = 10
opt.hlsearch = true
opt.showmatch = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.colorcolumn = "120"
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
