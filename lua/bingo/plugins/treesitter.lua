---@type LazySpec
return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		init = function()
			vim.api.nvim_create_autocmd("Filetype", {
				callback = function(args)
					local lang = vim.treesitter.language.get_lang(args.match) or args.match
					if vim.treesitter.language.add(lang) then
						require("nvim-treesitter")
							.install(lang)
							:await(function() vim.treesitter.start(args.buf, lang) end)
					end
				end,
			})
		end,
	},
	{ "nvim-treesitter/nvim-treesitter-context", opts = { multiwindow = true } },
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function() vim.g.no_plugin_maps = true end,
		---@type TSTextObjects.Config
		---@diagnostic disable-next-line: missing-fields
		opts = {
			select = {
				lookahead = true,
				selection_modes = {
					["@parameter.outer"] = "v",
					["@function.outer"] = "V",
					["@class.outer"] = "V",
				},
			},
		},
		config = function()
			local move = require("nvim-treesitter-textobjects.move")
			local select = require("nvim-treesitter-textobjects.select").select_textobject
			local swap = require("nvim-treesitter-textobjects.swap")
			local function map(mode, key, action, query, group)
				vim.keymap.set(mode, key, function() action(query, group) end, { desc = query })
			end
			-- select
			local select_mode = { "x", "o" }
			map(select_mode, "ac", select, "@class.outer")
			map(select_mode, "ic", select, "@class.inner")
			map(select_mode, "af", select, "@function.outer")
			map(select_mode, "if", select, "@function.inner")
			map(select_mode, "ai", select, "@conditional.outer")
			map(select_mode, "ii", select, "@conditional.inner")
			map(select_mode, "ap", select, "@parameter.outer")
			map(select_mode, "ip", select, "@parameter.inner")
			map(select_mode, "al", select, "@loop.outer")
			map(select_mode, "il", select, "@loop.inner")
			map(select_mode, "ar", select, "@return.outer")
			map(select_mode, "ir", select, "@return.inner")
			map(select_mode, "as", select, "@local.scope", "locals")
			map(select_mode, "is", select, "@local.scope", "locals")
			-- swap
			map("n", "gp", swap.swap_next, "@parameter.inner")
			map("n", "gP", swap.swap_previous, "@parameter.inner")
			-- move
			local move_mode = { "n", "x", "o" }
			map(move_mode, "]f", move.goto_next_start, "@function.outer")
			map(move_mode, "[f", move.goto_previous_start, "@function.outer")
			map(move_mode, "]F", move.goto_next_end, "@function.outer")
			map(move_mode, "[F", move.goto_previous_end, "@function.outer")
			map(move_mode, "]]", move.goto_next_start, "@class.outer")
			map(move_mode, "[[", move.goto_previous_start, "@class.outer")
			map(move_mode, "][", move.goto_next_end, "@class.outer")
			map(move_mode, "[]", move.goto_previous_end, "@class.outer")
			map(move_mode, "]s", move.goto_next_start, "@local.scope", "locals")
			map(move_mode, "[s", move.goto_previous_start, "@local.scope", "locals")
			map(move_mode, "]S", move.goto_next_end, "@local.scope", "locals")
			map(move_mode, "[S", move.goto_previous_end, "@local.scope", "locals")
		end,
	},
}
