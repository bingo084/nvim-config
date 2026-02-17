---@type LazySpec
return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
		"onsails/lspkind.nvim",
		"moyiz/blink-emoji.nvim",
		"MahanRahmati/blink-nerdfont.nvim",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			["<C-d>"] = { function(cmp) return cmp.select_next({ count = 5 }) end, "fallback" },
			["<C-u>"] = { function(cmp) return cmp.select_prev({ count = 5 }) end, "fallback" },
			["<C-j>"] = { "snippet_forward", "fallback" },
			["<C-k>"] = { "snippet_backward", "fallback" },
			["<C-b>"] = false,
			["<C-f>"] = false,
		},
		completion = {
			list = { selection = { auto_insert = false } },
			menu = {
				border = "rounded",
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon" },
						{ "kind" },
						{ "source_name" },
					},
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = require("lspkind").symbolic(ctx.kind)
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									icon = require("nvim-web-devicons").get_icon(ctx.label) or icon
								end
								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									_, hl = require("nvim-web-devicons").get_icon(ctx.label)
								end
								return hl or ctx.kind_hl
							end,
						},
						kind = {
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									_, hl = require("nvim-web-devicons").get_icon(ctx.label)
								end
								return hl or ctx.kind_hl
							end,
						},
						source_name = {
							text = function(ctx) return "[" .. ctx.source_name .. "]" end,
						},
					},
				},
			},
			documentation = { auto_show = true, window = { border = "rounded" } },
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "emoji", "nerdfont" },
			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
				sql = { inherit_defaults = true, "dadbod" },
			},
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				emoji = {
					name = "Emoji",
					module = "blink-emoji",
					score_offset = -3,
				},
				nerdfont = {
					name = "Nerd Fonts",
					module = "blink-nerdfont",
					score_offset = -3,
				},
				dadbod = {
					name = "Dadbod",
					module = "vim_dadbod_completion.blink",
					score_offset = 100,
				},
			},
		},
		cmdline = {
			keymap = {
				["<C-f>"] = { "select_and_accept", "fallback" },
			},
		},
	},
	opts_extend = { "sources.default" },
	event = { "InsertEnter", "CmdlineEnter" },
}
