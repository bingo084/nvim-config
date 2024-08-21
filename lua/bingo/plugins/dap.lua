---@type LazySpec
return {
	{ "mfussenegger/nvim-dap", version = "*", lazy = true },
	{
		"rcarriga/nvim-dap-ui",
		version = "*",
		opts = {
			icons = { expanded = "▾", collapsed = "▸" },
			layouts = {
				{
					elements = {
						-- Elements can be strings or table with id and size keys.
						{ id = "scopes", size = 0.25 },
						"repl",
						"breakpoints",
						"stacks",
						"watches",
					},
					size = 40, -- 40 columns
					position = "right",
				},
				{
					elements = {
						"console",
					},
					size = 0.35, -- 25% of total lines
					position = "bottom",
				},
			},
		},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup(opts)
			local sign = vim.fn.sign_define
			sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
			sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
			sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

			dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open({}) end
			dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close({}) end
			dap.listeners.before.event_exited["dapui_config"] = function() dapui.close({}) end
		end,
		keys = {
			{ "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Toggle Breakpoint" },
			{ "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Debug Continue" },
			{ "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Step Into" },
			{ "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Last" },
			{ "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Step Over" },
			{ "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Step Out" },
			{ "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Toggle Repl" },
			{ "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "Toggle UI" },
			{ "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", desc = "Debug Exit" },
		},
	},
}
