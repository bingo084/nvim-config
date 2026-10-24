---@type LazySpec
return {
	"folke/sidekick.nvim",
	dependencies = {
		"zbirenbaum/copilot.lua",
	},
	version = false,
	opts = {},
	keys = {
		{
			"<tab>",
			function()
				if not require("sidekick").nes_jump_or_apply() then
					return "<Tab>"
				end
			end,
			expr = true,
			desc = "Goto/Apply Next Edit Suggestion",
		},
		{
			"<leader>as",
			function() require("sidekick.nes").apply() end,
			desc = "Goto/Apply Next Edit Suggestion",
		},
	},
}
