local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	vim.notify("which_key is not found!")
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		-- ["<space>"] = "SPC",
		-- ["<cr>"] = "RET",
		-- ["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
	ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	show_keys = true, -- show the currently pressed key and its label as a message in the command line
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specify a list manually
	triggers_blacklist = {
		-- list of mode / prefixes that should never be hooked by WhichKey
		-- this is mostly relevant for key maps that start with a native binding
		-- most people should not need to change this
		i = { "j", "k" },
		v = { "j", "k" },
	},
	-- disable the WhichKey popup for certain buf types and file types.
	-- Disabled by deafult for Telescope
	disable = {
		buftypes = {},
		filetypes = { "TelescopePrompt" },
	},
}

local m_opts = {
	mode = "n", -- NORMAL mode
	prefix = "m",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local m_mappings = {
	a = { "<cmd>silent BookmarkAnnotate<cr>", "Annotate" },
	c = { "<cmd>silent BookmarkClear<cr>", "Clear" },
	b = { "<cmd>silent BookmarkToggle<cr>", "Toggle" },
	m = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
	["."] = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "Harpoon Next" },
	[","] = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "Harpoon Prev" },
	l = { "<cmd>lua require('user.bfs').open()<cr>", "Buffers" },
	j = { "<cmd>silent BookmarkNext<cr>", "Next" },
	s = { "<cmd>Telescope harpoon marks<cr>", "Search Files" },
	k = { "<cmd>silent BookmarkPrev<cr>", "Prev" },
	S = { "<cmd>silent BookmarkShowAll<cr>", "Prev" },
	-- s = {
	--   "<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>",
	--   "Show",
	-- },
	x = { "<cmd>BookmarkClearAll<cr>", "Clear All" },
	[";"] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
}

local opts = {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["a"] = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Action" },
	["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["\\"] = { "<cmd>vsplit<cr>", "Vsplit" },
	["-"] = { "<cmd>split<cr>", "Split" },
	["w"] = { "<cmd>w<CR>", "Write" },
	["q"] = { '<cmd>lua require("user.functions").smart_quit()<CR>', "Quit" },
	["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
	["1"] = { "<cmd>BufferLineGoToBuffer 1<CR>", "Buffer 1" },
	["2"] = { "<cmd>BufferLineGoToBuffer 2<CR>", "Buffer 2" },
	["3"] = { "<cmd>BufferLineGoToBuffer 3<CR>", "Buffer 3" },
	["4"] = { "<cmd>BufferLineGoToBuffer 4<CR>", "Buffer 4" },
	["5"] = { "<cmd>BufferLineGoToBuffer 5<CR>", "Buffer 5" },
	["6"] = { "<cmd>BufferLineGoToBuffer 6<CR>", "Buffer 6" },
	["7"] = { "<cmd>BufferLineGoToBuffer 7<CR>", "Buffer 7" },
	["8"] = { "<cmd>BufferLineGoToBuffer 8<CR>", "Buffer 8" },
	["9"] = { "<cmd>BufferLineGoToBuffer 9<CR>", "Buffer 9" },
	["$"] = { "<cmd>BufferLineGoToBuffer -1<CR>", "Last Buffer" },

	b = {
		name = "Buffer",
		a = { "<cmd>%bdelete!<CR>", "Close All" },
		c = { "<cmd>Bdelete!<CR>", "Close Current" },
		j = { "<cmd>BufferLineCloseLeft<CR>", "Close Left" },
		k = { "<cmd>BufferLineCloseRight<CR>", "Close Right" },
		o = { "<cmd>BufferLineCloseLeft<CR><cmd>BufferLineCloseRight<CR>", "Close Others" },
	},

	d = {
		name = "Debug",
		b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
		c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
		i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
		o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
		O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
		r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
		l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
		u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
		x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
	},

	f = {
		name = "Find",
		b = { "<cmd>Telescope buffers<cr>", "Buffer" },
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		C = { "<cmd>Telescope commands()<cr>", "Commands" },
		f = { "<cmd>Telescope find_files<cr>", "File" },
		h = { "<cmd>Telescope help_tags<cr>", "Help" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		l = { "<cmd>Telescope resume<cr>", "Last Search" },
		m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		p = { "<cmd>Telescope projects<cr>", "Projects" },
		r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
		R = { "<cmd>Telescope registers<cr>", "Registers" },
		t = { "<cmd>Telescope live_grep<cr>", "Text" },
		w = { "<cmd>Telescope grep_string<cr>", "Word" },
	},

	g = {
		name = "Git",
		b = { "<cmd>Telescope git_branches<cr>", "List branch" },
		c = { "<cmd>Telescope git_commits<cr>", "List Commit" },
		C = { "<cmd>Telescope git_bcommits<cr>", "List Buffer Commit" },
		d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
		g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
		j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
		k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
		l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
		o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
		p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
		r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
		R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
		s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
		u = { "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", "Undo Stage Hunk" },
	},

	l = {
		name = "Lsp",
		c = { "<cmd>lua require('user.plugin.lsp').server_capabilities()<cr>", "Get Capabilities" },
		d = { "<cmd>lua require('user.functions').toggle_diagnostics()<cr>", "Toggle Diagnostics" },
		h = { "<cmd>IlluminateToggle<cr>", "Toggle Doc HL" },
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>Mason<cr>", "Installer Info" },
		l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
		o = { "<cmd>SymbolsOutline<cr>", "Outline" },
		q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
		R = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
		u = { "<cmd>LuaSnipUnlinkCurrent<cr>", "Unlink Snippet" },
		w = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics" },
	},

	m = {
		name = "Markdown",
		p = { "<cmd>MarkdownPreviewToggle<CR>", "Toggle Markdown Preview" },
	},

	o = {
		name = "Options",
		w = { '<cmd>lua require("user.functions").toggle_option("wrap")<cr>', "Wrap" },
		r = { '<cmd>lua require("user.functions").toggle_option("relativenumber")<cr>', "Relative" },
		l = { '<cmd>lua require("user.functions").toggle_option("cursorline")<cr>', "Cursorline" },
		s = { '<cmd>lua require("user.functions").toggle_option("spell")<cr>', "Spell" },
		t = { '<cmd>lua require("user.functions").toggle_tabline()<cr>', "Tabline" },
	},

	p = {
		name = "Packer",
		c = { "<cmd>PackerCompile<cr>", "Compile" },
		i = { "<cmd>PackerInstall<cr>", "Install" },
		s = { "<cmd>PackerSync<cr>", "Sync" },
		S = { "<cmd>PackerStatus<cr>", "Status" },
		u = { "<cmd>PackerUpdate<cr>", "Update" },
	},

	s = {
		name = "Session",
		d = { "<cmd>Autosession delete<cr>", "Find Delete" },
		e = { [[<cmd>lua require("luasnip.loaders.from_lua").edit_snippet_files()<cr>]], "edit snip" },
		f = { "<cmd>SearchSession<cr>", "Find" },
		r = { "<cmd>RestoreSession<cr>", "Restore" },
		s = { "<cmd>SaveSession<cr>", "Save" },
		x = { "<cmd>DeleteSession<cr>", "Delete" },
	},

	t = {
		name = "Terminal",
		["1"] = { ":1ToggleTerm<cr>", "1" },
		["2"] = { ":2ToggleTerm<cr>", "2" },
		["3"] = { ":3ToggleTerm<cr>", "3" },
		["4"] = { ":4ToggleTerm<cr>", "4" },
		b = { "<cmd>lua _BTOP_TOGGLE()<cr>", "Btop" },
		["="] = { "<cmd>lua _FLOAT_TERM()<cr>", "Float" },
		["-"] = { "<cmd>lua _HORIZONTAL_TERM()<cr>", "Horizontal" },
		["\\"] = { "<cmd>lua _VERTICAL_TERM()<cr>", "Vertical" },
	},

	T = {
		name = "Treesitter",
		h = { "<cmd>TSHighlightCapturesUnderCursor<cr>", "Highlight" },
		p = { "<cmd>TSPlaygroundToggle<cr>", "Playground" },
		r = { "<cmd>TSToggle rainbow<cr>", "Rainbow" },
	},
}

local vopts = {
	mode = "v", -- VISUAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
	["/"] = { '<esc><cmd>lua require("Comment.api").toggle.blockwise(vim.fn.visualmode())<cr>', "Comment" },
	s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(m_mappings, m_opts)
