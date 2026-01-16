---@type LazySpec
return {
	{
		"kevinhwang91/nvim-bqf",
		dependencies = { { "junegunn/fzf", build = function() vim.fn["fzf#install"]() end } },
		opts = {
			auto_resize_height = true,
			preview = { winblend = 0 },
			func_map = {
				drop = "o",
				openc = "O",
				split = "<C-s>",
				tabc = "",
				tabdrop = "<C-t>",
				pscrollup = "<A-u>",
				pscrolldown = "<A-d>",
			},
			filter = { fzf = { action_for = { ["ctrl-s"] = "split" } } },
		},
		ft = "qf",
	},
	{
		"stevearc/quicker.nvim",
		---@module "quicker"
		---@type quicker.SetupOptions
		opts = {
			keys = {
				{ ">", function() require("quicker").expand({ add_to_existing = true }) end, desc = "Expand Context" },
				{ "<", function() require("quicker").collapse() end, desc = "Collapse Context" },
			},
		},
		ft = "qf",
	},
}
