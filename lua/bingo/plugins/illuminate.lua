return {
	"RRethy/vim-illuminate",
	opts = {
		filetypes_denylist = {
			"alpha",
			"NvimTree",
		},
		large_file_cutoff = 5000,
		large_file_overrides = nil,
	},
	config = function(_, opts)
		require("illuminate").configure({ opts })
	end,
	event = "VeryLazy",
	keys = {
		{ "<leader>lh", "<cmd>IlluminateToggle<cr>", desc = "Toggle Doc HL" },
	},
}
