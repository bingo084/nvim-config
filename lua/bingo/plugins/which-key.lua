---@type LazySpec
return {
	"folke/which-key.nvim",
	---@class wk.Opts
	opts = {
		---@type false | "classic" | "modern" | "helix"
		preset = "modern",
		--- You can add any mappings here, or use `require('which-key').add()` later
		---@type wk.Spec
		spec = {
			{ "<leader>a", group = "AI" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>c", group = "Copilot/Close" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>f", group = "Find" },
			{ "<leader>g", group = "Git" },
			{ "<leader>i", group = "Inline" },
			{ "<leader>l", group = "Lsp" },
			{ "<leader>m", group = "Markdown" },
			{ "<leader>n", group = "Notification" },
			{ "<leader>o", group = "Options" },
			{ "<leader>p", group = "Plugin" },
			{ "<leader>r", group = "Reload" },
			{ "<leader>s", group = "Session/Snip" },
			{ "<leader>t", group = "Terminal" },
			{ "<leader>T", group = "Treesitter" },
			{ "<leader>x", group = "Extract" },
		},
		icons = {
			---@type wk.IconRule[]|false
			rules = {
				-- Buffer
				{ pattern = "delete", icon = "󰆴", color = "red" },
				-- Copilot/Close
				{ pattern = "panel", icon = "", color = "blue" },
				{ pattern = "list", icon = "", color = "cyan" },
				{ pattern = "copilot", icon = "", color = "green" },
				{ pattern = "close", icon = "󱎘", color = "red" },
				-- Debug
				{ pattern = "breakpoint", icon = "", color = "red" },
				{ pattern = "continue", icon = "", color = "green" },
				{ pattern = "run last", icon = "", color = "green" },
				{ pattern = "step into", icon = "", color = "green" },
				{ pattern = "step out", icon = "", color = "green" },
				{ pattern = "step over", icon = "", color = "green" },
				{ pattern = "repl", icon = "", color = "blue" },
				{ pattern = "ui", icon = "󰙵", color = "cyan" },
				-- Find
				{ pattern = "command", icon = "", color = "purple" },
				{ pattern = "color", icon = "", color = "orange" },
				{ pattern = "grep", icon = "󱎸", color = "azure" },
				{ pattern = "help", icon = "󰋗", color = "blue" },
				{ pattern = "highlight", icon = "", color = "orange" },
				{ pattern = "icon", icon = "󰞅", color = "yellow" },
				{ pattern = "keymap", icon = "󰌌", color = "azure" },
				{ pattern = "config", icon = "", color = "blue" },
				{ pattern = "man", icon = "󱚊", color = "cyan" },
				{ pattern = "project", icon = "", color = "blue" },
				{ pattern = "resume", icon = "", color = "green" },
				{ pattern = "word", icon = "", color = "azure" },
				{ pattern = "zoxide", icon = "", color = "yellow" },
				{ pattern = "history", icon = "", color = "cyan" },
				-- Git
				{ pattern = "git", icon = "󰊢", color = "red" },
				{ pattern = "blame", icon = "󰕚", color = "orange" },
				{ pattern = "preview", icon = "", color = "azure" },
				{ pattern = "reset", icon = "", color = "red" },
				{ pattern = "stage", icon = "", color = "green" },
				{ pattern = "browse", icon = "", color = "orange" },
				{ pattern = "diff", icon = "", color = "yellow" },
				{ pattern = "status", icon = "󱖫", color = "blue" },
				{ pattern = "log", icon = "", color = "cyan" },
				-- Inline
				{ pattern = "inline", icon = "󰊈", color = "purple" },
				{ pattern = "variable", icon = "󰫧", color = "orange" },
				{ pattern = "function", icon = "󰊕", color = "blue" },
				-- Lsp
				{ pattern = "lsp", icon = "󰒋", color = "orange" },
				{ pattern = "diagnostic", icon = "󰒡", color = "red" },
				{ pattern = "format", icon = "󰣟", color = "green" },
				{ pattern = "info", icon = "", color = "blue" },
				{ pattern = "install", icon = "󰏓", color = "green" },
				{ pattern = "rename", icon = "󰑕", color = "orange" },
				-- Markdown
				{ pattern = "markdown", icon = "󰍔", color = "cyan" },
				-- Notification
				{ pattern = "dismiss", icon = "󱎘", color = "red" },
				-- Options
				{ pattern = "option", icon = "", color = "yellow" },
				-- Plugin
				{ pattern = "plugin", icon = "", color = "orange" },
				{ pattern = "check", icon = "", color = "azure" },
				{ pattern = "home", icon = "", color = "green" },
				{ pattern = "update", icon = "󰏕", color = "red" },
				-- Reload
				{ pattern = "load", icon = "󰦛", color = "cyan" },
				{ pattern = "lua", icon = "󰢱", color = "blue" },
				-- Session
				{ pattern = "save", icon = "", color = "green" },
				{ pattern = "edit", icon = "", color = "yellow" },
				-- Terminal
				{ pattern = "btop", icon = "󰨇", color = "cyan" },
				{ pattern = "docker", icon = "󰡨", color = "blue" },
				-- Extract
				{ pattern = "extract", icon = "", color = "yellow" },
				-- Write
				{ pattern = "write", icon = "", color = "green" },
			},
		},
	},
	config = function(_, opts)
		local rules = require("which-key.icons").rules
		local blocked_plugins = {
			"snacks.nvim",
			"noice.nvim",
		}
		for i = #rules, 1, -1 do
			if vim.tbl_contains(blocked_plugins, rules[i].plugin) then
				table.remove(rules, i)
			end
		end
		require("which-key").setup(opts)
	end,
	event = "VeryLazy",
}
