local options = {
	-- appearance
	showcmd = true, --右下角显示命令
	showmode = false, --右下角显示模式
	number = true, --行号
	relativenumber = true, --相对行号
	cmdheight = 1, --Number of screen lines to use for the command-line.
	termguicolors = true, --如果安装第三方主题，必须设置为true
	scrolloff = 8, --Minimal number of screen lines to keep above and below the cursor.
	conceallevel = 0, --隐藏字符语法高亮
	fileencoding = "utf-8", --utf8编码
	cursorline = true, --高亮当前行
	cursorcolumn = false, --不高亮当前列
	-- clipboard
	clipboard = "unnamedplus", --同步系统剪贴板
	mouse = "a", --允许鼠标
	-- search
	ignorecase = true, --查找时忽略大小写
	smartcase = true, --智能大小写
	hlsearch = true, --高亮搜索
	showmatch = true,
	-- indent
	smartindent = true, --智能锁进
	cindent = true,
	autoindent = true, --自动缩进
	tabstop = 2, --Tab宽度
	expandtab = true, --空格替换Tab
	shiftwidth = 2, --每次Shift调整的缩进
	showtabline = 2,
	wrap = false, --不自动换行
	undofile = true, --保存撤销历史
	signcolumn = "yes",
	colorcolumn = "80",
}
--应用上面配置
vim.opt.shortmess:append("c")
for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "*" },
	desc = "Disable automatic comment insertion",
	command = "set formatoptions-=ro",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_on_yank", {}),
	desc = "Highlight when yanking (copying) text",
	callback = function() vim.highlight.on_yank() end,
})
