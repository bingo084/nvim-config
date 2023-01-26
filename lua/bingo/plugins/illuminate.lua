return {
	"RRethy/vim-illuminate",
	opts = {
		filetypes_denylist = {
			"alpha",
			"NvimTree",
		},
		-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
		-- See `:help mode()` for possible values
		-- modes_denylist = { "v", "V" },
	},
	config = function(_, opts)
		require("illuminate").configure({ opts })
	end,
	event = "VeryLazy",
	keys = {
		{ "<leader>lh", "<cmd>IlluminateToggle<cr>", desc = "Toggle Doc HL" },
	},
}
