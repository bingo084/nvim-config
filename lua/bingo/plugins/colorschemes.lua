local function add_keys(plugins)
	for i, v in pairs(plugins) do
		if type(v) == "string" then
			plugins[i] = { v, keys = { { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Find Colorscheme" } } }
		elseif type(v) == "table" then
			plugins[i] = vim.tbl_extend(
				"keep",
				v,
				{ keys = { { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Find Colorscheme" } } }
			)
		end
	end
	return plugins
end
return add_keys({
	"morhetz/gruvbox",
	"folke/tokyonight.nvim",
	"Mofiqul/dracula.nvim",
	{
		"catppuccin/nvim",
		init = function() vim.cmd.colorscheme("catppuccin") end,
		name = "catppuccin",
		opts = {
			flavour = "macchiato",
			transparent_background = true,
			show_end_of_buffer = true,
			term_colors = true,
			integrations = {
				alpha = true,
				gitsigns = true,
				harpoon = true,
				indent_blankline = {
					enabled = true,
				},
				leap = true,
				markdown = true,
				mason = true,
				noice = true,
				cmp = true,
				dap = true,
				dap_ui = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
				navic = {
					enabled = true,
				},
				notify = true,
				treesitter_context = true,
				treesitter = true,
				rainbow_delimiters = true,
				telescope = {
					enabled = true,
				},
				illuminate = {
					enabled = true,
					lsp = true,
				},
				which_key = true,
			},
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
