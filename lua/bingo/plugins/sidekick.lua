---@type LazySpec
return {
	"folke/sidekick.nvim",
	version = false,
	opts = {
		nes = { enabled = false },
		copilot = { status = { enabled = false } },
		cli = {
			win = {
				config = function(terminal)
					if terminal.tool.name == "codex" then
						vim.list_extend(terminal.tool.cmd, { "--cd", terminal.cwd })
					end
				end,
				keys = {
					buffers = false,
					files = false,
					prompt = false,
					stopinsert = false,
					hide_ctrl_z = false,
					nav_left = false,
					nav_down = false,
					nav_up = false,
					nav_right = false,
				},
			},
			tools = {
				codex = {
					cmd = {
						"codex",
						"resume",
						"--remote",
						"unix://",
						"--last",
						"-c",
						'tui.notification_method="osc9"',
						"-c",
						'tui.notification_condition="always"',
					},
				},
			},
		},
	},
	keys = {
		{
			"<C-.>",
			function() require("sidekick.cli").toggle({ name = "codex" }) end,
			mode = { "n", "i", "x", "t" },
			desc = "Toggle Codex",
		},
		{
			"<leader>af",
			function() require("sidekick.cli").send({ name = "codex", msg = "{file}" }) end,
			desc = "Send File to Codex",
		},
		{
			"<leader>at",
			function() require("sidekick.cli").send({ name = "codex", msg = "{this}" }) end,
			mode = { "n", "x" },
			desc = "Send Context to Codex",
		},
	},
}
