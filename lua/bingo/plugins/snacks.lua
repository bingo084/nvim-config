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
		quickfile = {},
	},
	keys = {
		-- Bufdelete
		{ "<leader>ba", function() Snacks.bufdelete.all() end, desc = "Delete All" },
		{ "<leader>bA", function() Snacks.bufdelete.all({ force = true }) end, desc = "Force Delete All" },
		{ "<leader>bd", function() Snacks.bufdelete.delete() end, desc = "Delete" },
		{ "<leader>bD", function() Snacks.bufdelete.delete({ force = true }) end, desc = "Force Delete" },
		{ "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other" },
		{ "<leader>bO", function() Snacks.bufdelete.other({ force = true }) end, desc = "Force Delete Other" },
		-- Git
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Browse", mode = { "n", "v" } },
		-- Lazygit
		{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>lG", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File" },
		-- Picker
		{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
		{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>;", function() Snacks.picker.command_history() end, desc = "Command History" },

		{ "<leader>fa", function() Snacks.picker.autocmds() end, desc = "Autocommands" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fB", function() Snacks.picker.buffers({ modified = true }) end, desc = "Modified Buffers" },
		{ "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands" },
		{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },
		{ "<leader>fg", function() Snacks.picker.git_status() end, desc = "Git Changes" },
		{ "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights" },
		{ "<leader>fi", function() Snacks.picker.icons() end, desc = "Icons" },
		{ "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
		{ "<leader>fk", function() Snacks.picker.keymaps({ confirm = "jump" }) end, desc = "Keymaps" },
		{ "<leader>fl", function() Snacks.picker.lsp_config() end, desc = "LSP Config" },
		{ "<leader>fm", function() Snacks.picker.man() end, desc = "Man Pages" },
		{ "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notifications" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
		{
			"<leader>fs",
			function()
				Snacks.picker.scratch({
					win = {
						input = {
							keys = {
								["<c-n>"] = { "list_down", mode = { "n", "i" } },
								["<a-n>"] = { "scratch_new", mode = { "n", "i" } },
							},
						},
					},
				})
			end,
			desc = "Scratch",
		},
		{ "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Words" },
		{ "<leader>fz", function() Snacks.picker.zoxide() end, desc = "Zoxide" },
		{ "<leader>f/", function() Snacks.picker.search_history() end, desc = "Search History" },
		-- Scratch
		{ "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
	},
}
