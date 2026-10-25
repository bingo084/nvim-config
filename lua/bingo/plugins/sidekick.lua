---@type LazySpec
return {
	"folke/sidekick.nvim",
	version = false,
	init = function() require("bingo.terminal-colors").setup() end,
	opts = {
		nes = { enabled = false },
		copilot = { status = { enabled = false } },
		cli = {
			context = {
				diagnostics_line = function(ctx)
					return require("sidekick.cli.context.diagnostics").get(ctx, { lnum = ctx.row - 1 })
				end,
			},
			win = {
				config = function(terminal)
					if terminal.tool.name == "codex" then
						require("bingo.terminal-colors").prepare()
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
			"<leader>ad",
			function() require("sidekick.cli").send({ name = "codex", msg = "{diagnostics_line}" }) end,
			desc = "Send Line Diagnostics to Codex",
		},
		{
			"<leader>aD",
			function() require("sidekick.cli").send({ name = "codex", msg = "{diagnostics}" }) end,
			desc = "Send File Diagnostics to Codex",
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
