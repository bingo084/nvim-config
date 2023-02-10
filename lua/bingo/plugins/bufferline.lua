return {
	"akinsho/bufferline.nvim",
	lazy = false,
	opts = {
		options = {
			numbers = "ordinal", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
			close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
			right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
			left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
			middle_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
			indicator = {
				style = "icon",
				icon = " ",
			},
			tab_size = 10,
			offsets = { { filetype = "NvimTree", text = "EXPLORER", text_align = "left" } },
			show_close_icon = false,
			separator_style = { "", "" },
		},
		highlights = {
			fill = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "StatusLineNC" },
			},
			background = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
			buffer_visible = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
			buffer_selected = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "Normal" },
				bold = true,
			},
			numbers = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
			numbers_visible = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
			numbers_selected = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "Normal" },
				bold = true,
			},
			modified = {
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
			modified_visible = {
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
			modified_selected = {
				bg = { attribute = "bg", highlight = "Normal" },
			},
			close_button = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
			close_button_selected = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "Normal" },
			},
			close_button_visible = {
				fg = { attribute = "fg", highlight = "Normal" },
				bg = { attribute = "bg", highlight = "StatusLine" },
			},
		},
	},
	keys = {
		{ "<leader>k", "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer" },
		{ "<leader>j", "<cmd>BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
		{ "<leader>ba", "<cmd>%bdelete!<CR>", desc = "Close All Buffer" },
		{ "<leader>bj", "<cmd>BufferLineCloseLeft<CR>", desc = "Close Left Buffer" },
		{ "<leader>bk", "<cmd>BufferLineCloseRight<CR>", desc = "Close Right Buffer" },
		{ "<leader>bo", "<cmd>BufferLineCloseLeft<CR><cmd>BufferLineCloseRight<CR>", desc = "Close Other Buffer" },
		{ "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Buffer 1" },
		{ "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Buffer 2" },
		{ "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Buffer 3" },
		{ "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Buffer 4" },
		{ "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Buffer 5" },
		{ "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Buffer 6" },
		{ "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Buffer 7" },
		{ "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Buffer 8" },
		{ "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Buffer 9" },
		{ "<leader>0", "<cmd>BufferLineGoToBuffer -1<CR>", desc = "Last Buffer" },
	},
}
