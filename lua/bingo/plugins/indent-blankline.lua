return {
	"lukas-reineke/indent-blankline.nvim",
	opts = {
		char = "▏",
		show_current_context = true,
		show_trailing_blankline_indent = false,
		show_first_indent_level = false,
		use_treesitter = true,
		use_treesitter_scope = false,
		filetype_exclude = {
			"help",
			"startify",
			"dashboard",
			"packer",
			"neogitstatus",
			"nvimtree",
			"trouble",
			"text",
		},
	},
	event = "VeryLazy",
}
