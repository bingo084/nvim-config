local function ui() return require("harpoon").ui end
local function list() return require("harpoon"):list() end
local function oil() return require("oil") end
local function oil_select(opts)
	return oil().select(vim.tbl_extend("force", { split = "belowright", close = true }, opts))
end
---@type LazySpec
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
			{ "<C-m>", function() list():add() end, desc = "Harpoon Append" },
			{ "<C-h>", function() list():select(1) end, desc = "Harpoon Select 1" },
			{ "<C-j>", function() list():select(2) end, desc = "Harpoon Select 2" },
			{ "<C-k>", function() list():select(3) end, desc = "Harpoon Select 3" },
			{ "<C-l>", function() list():select(4) end, desc = "Harpoon Select 4" },
			{ "<C-;>", function() list():prev() end, desc = "Harpoon Prev" },
			{ "<C-'>", function() list():next() end, desc = "Harpoon next" },
		},
	},
	{
		"mikavilpas/yazi.nvim",
		---@module "yazi"
		---@type YaziConfig
		opts = {
			open_for_directories = true,
			open_multiple_tabs = true,
			floating_window_scaling_factor = 0.8,
			keymaps = {
				show_help = "~",
			},
		},
		event = "VeryLazy",
		keys = {
			{ "<leader>e", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
			{ "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
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
