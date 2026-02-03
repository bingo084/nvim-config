---@type LazySpec
return {
	{
		"windwp/nvim-autopairs",
		opts = {
			check_ts = true,
			map_c_h = true,
			map_c_w = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				java = false,
			},
		},
		event = "InsertEnter",
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
		event = "InsertEnter",
	},
	{
		"zbirenbaum/copilot.lua",
		opts = {
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-f>",
					accept_word = "<A-f>",
					accept_line = "<C-l>",
					next = "<C-n>",
					prev = "<C-p>",
					dismiss = "<C-b>",
				},
			},
			filetypes = {
				["*"] = true,
			},
		},
		event = "InsertEnter",
		keys = {
			{ "<leader>cp", function() require("copilot.panel").open({}) end, desc = "Copilot Panel" },
		},
	},
}
