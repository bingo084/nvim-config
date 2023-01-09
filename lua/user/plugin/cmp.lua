local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local compare = require("cmp.config.compare")

local lspkind_status_ok, lspkind = pcall(require, "lspkind")
if not lspkind_status_ok then
	vim.notify("lspkind is not found!")
	return
end

local icons = require("user.icons")

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#CA42F0" })
vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#FDE030" })
vim.api.nvim_set_hl(0, "CmpItemKindCrate", { fg = "#F64D00" })

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
		["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "c" }),
		["<Tab>"] = cmp.mapping(
			cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
			{ "i", "c" }
		),
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
		["<C-u>"] = cmp.mapping(
			cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select, count = 10 }),
			{ "i", "c" }
		),
		["<C-d>"] = cmp.mapping(
			cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select, count = 10 }),
			{ "i", "c" }
		),
	}),
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			menu = {
				nvim_lsp = "[Lsp]",
				nvim_lua = "[Lua]",
				luasnip = "[Luasnip]",
				buffer = "[Buffer]",
				path = "[Path]",
				emoji = "[Emoji]",
			},
			symbol_map = { Copilot = icons.git.Octoface, Emoji = icons.misc.Smiley, Snippet = icons.kind.Snippet },
			before = function(entry, vim_item)
				if entry.source.name == "cmp_tabnine" then
					vim_item.kind = icons.misc.Robot
					vim_item.kind_hl_group = "CmpItemKindTabnine"
				end

				if entry.source.name == "copilot" then
					vim_item.kind = icons.git.Octoface
					vim_item.kind_hl_group = "CmpItemKindCopilot"
				end

				if entry.source.name == "emoji" then
					vim_item.kind = icons.misc.Smiley
					vim_item.kind_hl_group = "CmpItemKindEmoji"
				end
				return vim_item
			end,
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "emoji" },
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			-- require("copilot_cmp.comparators").prioritize,
			-- require("copilot_cmp.comparators").score,
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
			-- require("copilot_cmp.comparators").prioritize,
			-- require("copilot_cmp.comparators").score,
		},
	},
})

cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})
