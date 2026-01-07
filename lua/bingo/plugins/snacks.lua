---@type LazySpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md#-debug
				_G.dd = function(...) Snacks.debug.inspect(...) end
				_G.bt = function() Snacks.debug.backtrace() end
				if vim.fn.has("nvim-0.11") == 1 then
					---@diagnostic disable-next-line: duplicate-set-field
					vim._print = function(_, ...) dd(...) end
				else
					vim.print = _G.dd
				end
				-- Create some toggle mappings
				Snacks.toggle.dim():map("<leader>od")
			end,
		})
	end,
	---@module "snacks"
	---@type snacks.Config
	opts = {
		bigfile = {},
		image = {},
		picker = {},
	},
	keys = {
		-- Git
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "[G]it [B]rowse", mode = { "n", "v" } },
		-- Lazygit
		{ "<leader>lg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>lG", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File" },
	},
}
