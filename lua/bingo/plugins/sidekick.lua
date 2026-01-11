---@type LazySpec
return {
	"folke/sidekick.nvim",
	dependencies = {
		"zbirenbaum/copilot.lua",
	},
	---@class sidekick.Config
	opts = {
		cli = {
			---@class sidekick.win.Opts
			win = {
				keys = {
					buffers = { "<leader>fb", "buffers", mode = "nt", desc = "open buffer picker" },
					files = { "<leader>ff", "files", mode = "nt", desc = "open file picker" },
					prompt = { "<leader>ap", "prompt", mode = "t", desc = "insert prompt or context" },
					stopinsert = { "jk", "stopinsert", mode = "t", desc = "enter normal mode" },
					nav_left = { "<A-h>", "nav_left", expr = true, desc = "navigate to the left window" },
					nav_down = { "<A-j>", "nav_down", expr = true, desc = "navigate to the below window" },
					nav_up = { "<A-k>", "nav_up", expr = true, desc = "navigate to the above window" },
					nav_right = { "<A-l>", "nav_right", expr = true, desc = "navigate to the right window" },
				},
			},
			---@type table<string, sidekick.cli.Config|{}>
			tools = {
				gemini = {
					cmd = {
						"bash",
						"-c",
						"gemini -m gemini-2.5-pro --resume 2> >(grep -v 'No previous sessions found') || gemini -m gemini-2.5-pro",
					},
				},
			},
		},
	},
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
		{
			"<c-.>",
			function() require("sidekick.cli").toggle({ filter = { installed = true } }) end,
			desc = "Sidekick Toggle",
			mode = { "n", "t", "i", "x" },
		},
		{
			"<leader>at",
			function() require("sidekick.cli").send({ msg = "{this}" }) end,
			mode = { "x", "n" },
			desc = "Send This To Sidekick",
		},
		{
			"<leader>af",
			function() require("sidekick.cli").send({ msg = "{file}" }) end,
			desc = "Send File To Sidekick",
		},
		{
			"<leader>av",
			function() require("sidekick.cli").send({ msg = "{selection}" }) end,
			mode = { "x" },
			desc = "Send Visual Selection To Sidekick",
		},
		{
			"<leader>ap",
			function() require("sidekick.cli").prompt() end,
			mode = { "n", "x" },
			desc = "Sidekick Select Prompt",
		},
	},
}
