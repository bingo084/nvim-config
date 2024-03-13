local function ui() return require("harpoon").ui end
local function list() return require("harpoon"):list() end
local function oil() return require("oil") end
local function oil_select(opts)
	return oil().select(vim.tbl_extend("force", { split = "belowright", close = true }, opts))
end
return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			local extensions = require("harpoon.extensions")
			harpoon:setup({ settings = { save_on_toggle = true } })
			harpoon:extend({
				UI_CREATE = function(cx)
					local function menu_map(key, opt)
						vim.keymap.set("n", key, function() ui():select_menu_item(opt) end, { buffer = cx.bufnr })
					end
					menu_map("<C-v>", { vsplit = true })
					menu_map("<C-s>", { split = true })
					menu_map("<C-t>", { tabedit = true })
				end,
			})
			harpoon:extend(extensions.builtins.navigate_with_number())
		end,
		keys = {
			{ "<C-e>", function() ui():toggle_quick_menu(list()) end, desc = "Harpoon Menu" },
			{ "<C-m>", function() list():append() end, desc = "Harpoon Append" },
			{ "<C-h>", function() list():select(1) end, desc = "Harpoon Select 1" },
			{ "<C-j>", function() list():select(2) end, desc = "Harpoon Select 2" },
			{ "<C-k>", function() list():select(3) end, desc = "Harpoon Select 3" },
			{ "<C-l>", function() list():select(4) end, desc = "Harpoon Select 4" },
			{ "<C-;>", function() list():prev() end, desc = "Harpoon Prev" },
			{ "<C-'>", function() list():next() end, desc = "Harpoon next" },
		},
	},
	{
		"stevearc/oil.nvim",
		init = function(plugin)
			-- https://github.com/kevinm6/nvim/blob/00e154d74711601a9d3d73fb5e0308d22076d828/lua/plugins/editor/oil.lua#L147
			if vim.fn.argc() == 1 then
				local argv = tostring(vim.fn.argv(0))
				local stat = vim.loop.fs_stat(argv)
				local remote_dir_args = vim.startswith(argv, "ssh")
				if stat and stat.type == "directory" or remote_dir_args then
					require("lazy").load({ plugins = { plugin.name } })
				end
			end
			if not require("lazy.core.config").plugins[plugin.name]._.loaded then
				vim.api.nvim_create_autocmd("BufNew", {
					callback = function(args)
						if vim.fn.isdirectory(args.file) == 1 then
							require("lazy").load({ plugins = { plugin.name } })
							return true
						end
					end,
				})
			end
		end,
		opts = {
			delete_to_trash = true,
			keymaps = {
				["<C-h>"] = false,
				["<C-s>"] = function() oil_select({ horizontal = true }) end,
				["<C-v>"] = function() oil_select({ vertical = true }) end,
				["<C-p>"] = function()
					local float = vim.api.nvim_win_get_config(0).relative ~= ""
					oil().close()
					if float then
						oil().open()
						oil_select({ preview = true, close = false })
					else
						oil().open_float()
					end
				end,
				["q"] = "actions.close",
				["<leader>e"] = "actions.close",
				["<Esc><Esc>"] = "actions.close",
			},
			float = {
				max_height = 16,
				override = function(conf)
					conf.row = (vim.o.lines - conf.height - 4)
					return conf
				end,
			},
			adapter_aliases = {
				["ssh://"] = "oil-ssh://",
			},
		},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>e", function() oil().open_float() end, desc = "Explorer" },
		},
	},
	{
		"ggandor/leap.nvim",
		config = function() require("leap").add_default_mappings() end,
		keys = {
			"s",
			"S",
		},
	},
}
