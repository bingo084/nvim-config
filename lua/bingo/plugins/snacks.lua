local picker_common_keys = {
	["<Space>"] = "select_and_next",
	["<C-j>"] = { "history_forward", mode = { "i", "n" } },
	["<C-k>"] = { "history_back", mode = { "i", "n" } },
	["<C-/>"] = { "toggle_help_input", mode = { "i", "n" } },
	["<A-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
	["<A-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
	["<A-H>"] = { "layout_left", mode = { "i", "n" } },
	["<A-J>"] = { "layout_bottom", mode = { "i", "n" } },
	["<A-K>"] = { "layout_top", mode = { "i", "n" } },
	["<A-L>"] = { "layout_right", mode = { "i", "n" } },
}
---@type LazySpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md#-debug
				_G.dd = function(...) Snacks.debug.inspect(...) end
				_G.bt = function() Snacks.debug.backtrace() end
				if vim.fn.has("nvim-0.11") == 1 then
					---@diagnostic disable-next-line: duplicate-set-field
					vim._print = function(_, ...) dd(...) end
				else
					vim.print = _G.dd
				end
				-- Create some toggle mappings
				Snacks.toggle.dim():map("<leader>od")
				-- -- Create some custom layouts
				-- require("snacks.picker.config.layouts").default = {
				-- 	hidden = { "preview" },
				-- 	layout = {
				-- 		backdrop = false,
				-- 		row = 0.65,
				-- 		width = 0.3,
				-- 		min_width = 40,
				-- 		anchor = "SW",
				-- 		box = "vertical",
				-- 		{ win = "preview", title = "{preview}", height = 0.35, border = true },
				-- 		{
				-- 			box = "vertical",
				-- 			height = 0.3,
				-- 			border = true,
				-- 			title = "{title} {live} {flags}",
				-- 			title_pos = "center",
				-- 			{ win = "input", height = 1, border = "bottom" },
				-- 			{ win = "list", border = "none" },
				-- 		},
				-- 	},
				-- }
			end,
		})
	end,
	---@module "snacks"
	---@type snacks.Config
	opts = {
		bigfile = {},
		image = {},
		---@class snacks.picker.Config
		picker = {
			prompt = " 󰍉 ",
			win = {
				input = {
					keys = vim.tbl_extend("force", {
						["jk"] = { "<Esc>", expr = true, mode = "i" },
						["<C-b>"] = { "<Left>", expr = true, mode = "i" },
						["<C-f>"] = { "<Right>", expr = true, mode = "i" },
					}, picker_common_keys),
				},
				list = { keys = picker_common_keys },
				preview = { keys = picker_common_keys },
			},
		},
	},
	keys = {
		-- Bufdelete
		{ "<leader>ba", function() Snacks.bufdelete.all() end, desc = "[B]uffer Delete [A]ll" },
		{ "<leader>bA", function() Snacks.bufdelete.all({ force = true }) end, desc = "[B]uffer Force Delete [A]ll" },
		{ "<leader>bd", function() Snacks.bufdelete.delete() end, desc = "[B]uffer [D]elete" },
		{ "<leader>bD", function() Snacks.bufdelete.delete({ force = true }) end, desc = "[B]uffer Force [D]elete" },
		{ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "[B]uffer Delete [O]ther" },
		{
			"<leader>bO",
			function() Snacks.bufdelete.other({ force = true }) end,
			desc = "[B]uffer Force Delete [O]ther",
		},
		-- Git
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "[G]it [B]rowse", mode = { "n", "v" } },
		-- Lazygit
		{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>lG", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File" },
		-- Picker
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>;", function() Snacks.picker.command_history() end, desc = "Command History" },

		{ "<leader>fa", function() Snacks.picker.autocmds() end, desc = "[F]ind [A]utocommands" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "[F]ind [B]uffers" },
		{
			"<leader>fB",
			function() Snacks.picker.buffers({ modified = true }) end,
			desc = "[F]ind Modified [B]uffers",
		},
		{ "<leader>fc", function() Snacks.picker.commands() end, desc = "[F]ind [C]ommands" },
		{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "[F]ind [D]iagnostics" },
		{ "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "[F]ind Buffer [D]iagnostics" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "[F]ind [F]iles" },
		{ "<leader>fg", function() Snacks.picker.git_status() end, desc = "[F]ind [G]it Changes" },
		{ "<leader>fh", function() Snacks.picker.help() end, desc = "[F]ind [H]elp Pages" },
		{ "<leader>fH", function() Snacks.picker.highlights() end, desc = "[F]ind [H]ighlights" },
		{ "<leader>fi", function() Snacks.picker.icons() end, desc = "[F]ind [I]cons" },
		{ "<leader>fj", function() Snacks.picker.jumps() end, desc = "[F]ind [J]umps" },
		{ "<leader>fk", function() Snacks.picker.keymaps({ confirm = "jump" }) end, desc = "[F]ind [K]eymaps" },
		{ "<leader>fl", function() Snacks.picker.lsp_config() end, desc = "[F]ind [L]SP Config" },
		{ "<leader>fm", function() Snacks.picker.man() end, desc = "[F]ind [M]an Pages" },
		{ "<leader>fn", function() Snacks.picker.notifications() end, desc = "[F]ind [N]otifications" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "[F]ind [P]rojects" },
		{ "<leader>fr", function() Snacks.picker.resume() end, desc = "[F]ind [R]esume" },
		{ "<leader>fw", function() Snacks.picker.grep_word() end, desc = "[F]ind [W]ords" },
		{ "<leader>fz", function() Snacks.picker.zoxide() end, desc = "[F]ind [Z]oxide" },
		{ "<leader>f/", function() Snacks.picker.search_history() end, desc = "[F]ind Search History" },
	},
}
