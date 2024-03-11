return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-emoji",
			"onsails/lspkind.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local mapping = cmp.mapping
			local select = cmp.SelectBehavior.Select
			local compare = require("cmp.config.compare")

			vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
			vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
			vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = mapping.preset.insert({
					["<C-b>"] = mapping.scroll_docs(-1),
					["<C-f>"] = mapping.scroll_docs(1),
					["<C-Space>"] = mapping(mapping.complete(), { "i", "c" }),
					["<C-e>"] = mapping(mapping.abort(), { "i", "c" }),
					["<CR>"] = { i = mapping.confirm({ select = true }), c = mapping.confirm() },
					["<Tab>"] = mapping(
						mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
						{ "i", "c" }
					),
					["<C-p>"] = mapping(mapping.select_prev_item({ behavior = select }), { "i", "c" }),
					["<C-n>"] = mapping(mapping.select_next_item({ behavior = select }), { "i", "c" }),
					["<C-u>"] = mapping(mapping.select_prev_item({ behavior = select, count = 10 }), { "i", "c" }),
					["<C-d>"] = mapping(mapping.select_next_item({ behavior = select, count = 10 }), { "i", "c" }),
				}),
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						menu = {
							nvim_lsp = "[Lsp]",
							luasnip = "[Luasnip]",
							buffer = "[Buffer]",
							path = "[Path]",
							emoji = "[Emoji]",
						},
						symbol_map = {
							Copilot = "",
							Emoji = "",
							Snippet = "",
						},
						before = function(entry, vim_item)
							if entry.source.name == "copilot" then
								vim_item.kind = ""
								vim_item.kind_hl_group = "CmpItemKindCopilot"
							end

							if entry.source.name == "emoji" then
								vim_item.kind = ""
								vim_item.kind_hl_group = "CmpItemKindEmoji"
							end
							return vim_item
						end,
					}),
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "emoji" },
				},
				sorting = {
					priority_weight = 2,
					comparators = {
						compare.offset,
						compare.exact,
						-- compare.scopes,
						compare.score,
						compare.recently_used,
						compare.locality,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},
			})

			cmp.setup.cmdline({ "/", "?" }, {
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				sources = {
					{ name = "path" },
					{ name = "cmdline" },
				},
			})

			cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
		end,
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
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
	},
}
