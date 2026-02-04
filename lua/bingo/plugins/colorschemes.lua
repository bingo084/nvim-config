---@param plugins LazySpec[]
local function add_keys(plugins)
	for i, v in pairs(plugins) do
		local keys = { { "<leader>fC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" } }
		if type(v) == "string" then
			plugins[i] = { v, keys = keys }
		elseif type(v) == "table" then
			plugins[i] = vim.tbl_extend("keep", v, { keys = keys })
		end
	end
	return plugins
end
return add_keys({
	{ "morhetz/gruvbox", version = false },
	"folke/tokyonight.nvim",
	"Mofiqul/dracula.nvim",
	{
		"catppuccin/nvim",
		version = false,
		init = function() vim.cmd.colorscheme("catppuccin") end,
		name = "catppuccin",
		opts = {
			flavour = "auto",
			background = { light = "latte", dark = "frappe" },
			transparent_background = true,
			float = { transparent = true, solid = true },
			show_end_of_buffer = true,
			term_colors = true,
			auto_integrations = true,
		},
	},
	{
		"Mofiqul/vscode.nvim",
		init = function()
			-- vim.cmd.colorscheme("vscode")
			-- Illuminate color
			-- vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#474747" })
			-- vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#474747" })
			-- vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#474747" })
		end,
		config = function() vim.g.vscode_italic_comment = 1 end,
	},
	"tomasiser/vim-code-dark",
	{
		"martinsione/darkplus.nvim",
	},
	{
		"navarasu/onedark.nvim",
		opts = {
			style = "darker",
		},
	},
})
