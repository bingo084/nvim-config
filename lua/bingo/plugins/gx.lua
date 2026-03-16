---@type LazySpec
return {
	"chrishrb/gx.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	init = function() vim.g.netrw_nogx = 1 end,
	submodules = false,
	opts = {},
	keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
}
