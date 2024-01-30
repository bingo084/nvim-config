return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			filetypes_denylist = {
				"alpha",
				"NvimTree",
			},
			modes_denylist = { "v" },
			large_file_cutoff = 5000,
			large_file_overrides = nil,
		})
	end,
	event = "VeryLazy",
	keys = {
		{ "<leader>lh", "<cmd>IlluminateToggle<cr>", desc = "Toggle Doc HL" },
	},
}
