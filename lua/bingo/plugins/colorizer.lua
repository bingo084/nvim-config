return {
	"norcalli/nvim-colorizer.lua",
	opts = {
    "*",
		css = {
			RRGGBBAA = true,
			rgb_fn = true,
			hsl_fn = true,
			css = true,
			css_fn = true,
		},
	},
	ft = { "css" },
	keys = {
		{ "<leader>oc", "<cmd>ColorizerToggle<cr>", desc = "Toggle Colorizer" },
  }
}
