return {
	"zbirenbaum/copilot.lua",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			debounce = 75,
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
			markdown = true,
		},
	},
	event = { "InsertEnter" },
}
