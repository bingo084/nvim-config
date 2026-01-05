---@type LazySpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@module "snacks"
	---@type snacks.Config
	opts = {
		lazygit = {},
	},
	keys = {
		{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>lG", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File" },
	},
}
