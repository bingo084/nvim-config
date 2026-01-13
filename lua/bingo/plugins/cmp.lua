---@type LazySpec
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
		version = false,
		config = function()
			local cmp = require("cmp")
			local mapping = cmp.mapping
			local select = cmp.SelectBehavior.Select
			local replace = cmp.ConfirmBehavior.Replace
			local luasnip = require("luasnip")

			vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })

			cmp.setup({
				snippet = {
					expand = function(args) luasnip.lsp_expand(args.body) end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = {
					["<A-d>"] = mapping(mapping.scroll_docs(1), { "i", "c" }),
					["<A-u>"] = mapping(mapping.scroll_docs(-1), { "i", "c" }),
					["<C-p>"] = mapping(mapping.select_prev_item({ behavior = select }), { "i", "c" }),
					["<C-n>"] = mapping(mapping.select_next_item({ behavior = select }), { "i", "c" }),
					["<C-e>"] = mapping(mapping.abort(), { "i", "c" }),
					-- ["<CR>"] = { i = mapping.confirm({ select = true }), c = mapping.confirm() },
					["<C-y>"] = mapping(mapping.confirm({ select = true }), { "i", "c" }),
					["<C-Space>"] = mapping(mapping.complete({}), { "i", "c" }),
					["<C-d>"] = mapping(mapping.select_next_item({ behavior = select, count = 10 }), { "i", "c" }),
					["<C-u>"] = mapping(mapping.select_prev_item({ behavior = select, count = 10 }), { "i", "c" }),
					["<Tab>"] = mapping(mapping.confirm({ behavior = replace, select = true }), { "i", "c" }),
					["<C-j>"] = mapping(function(fallback)
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-k>"] = mapping(function(fallback)
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-l>"] = mapping(function(fallback)
						if luasnip.choice_active() then
							luasnip.change_choice(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-f>"] = mapping(function(fallback)
						if luasnip.choice_active() then
							require("luasnip.extras.select_choice")()
						else
							fallback()
						end
					end, { "i", "s" }),
				},
				---@diagnostic disable-next-line: missing-fields
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "symbol_text",
						menu = {
							nvim_lsp = "[Lsp]",
							luasnip = "[LuaSnip]",
							buffer = "[Buffer]",
							path = "[Path]",
							emoji = "[Emoji]",
							lazydev = "[LazyDev]",
						},
						before = function(entry, vim_item)
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
					{ name = "lazydev", group_index = 0 },
				},
			})

			---@diagnostic disable-next-line: param-type-mismatch, missing-fields
			cmp.setup.cmdline({ "/", "?" }, {
				sources = {
					{ name = "buffer" },
				},
			})

			---@diagnostic disable-next-line: missing-fields
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
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" },
		build = "make install_jsregexp",
		config = function()
			local types = require("luasnip.util.types")
			require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets/" } })
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip").setup({
				update_events = "TextChanged,TextChangedI",
				region_check_events = "CursorMoved",
				enable_autosnippets = true,
				ext_opts = {
					[types.choiceNode] = {
						active = {
							virt_text = { { "", "DiagnosticHint" } },
						},
					},
					[types.insertNode] = {
						active = {
							virt_text = { { "", "DiagnosticHint" } },
						},
					},
				},
			})
		end,
		keys = {
			{ "<leader>se", function() require("luasnip.loaders").edit_snippet_files() end, desc = "Snip Edit" },
		},
	},
}
