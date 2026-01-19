---@type LazySpec
return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	event = "VeryLazy",
	keys = {
		{ "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "TODO comments" },
	},
}
