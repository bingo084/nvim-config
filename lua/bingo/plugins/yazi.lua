---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	init = function(plugin)
		-- https://github.com/kevinm6/nvim/blob/0be7d3b1ece79ac5cca048ead5748681210defde/lua/plugins/editor/oil.lua#L150
		if vim.fn.argc() == 1 then
			local argv = tostring(vim.fn.argv(0))
			local stat = (vim.uv or vim.loop).fs_stat(argv)
			if stat and stat.type == "directory" then
				require("lazy").load({ plugins = { plugin.name } })
			end
		end
		if not require("lazy.core.config").plugins[plugin.name]._.loaded then
			vim.api.nvim_create_autocmd("BufNew", {
				pattern = "*/",
				group = vim.api.nvim_create_augroup("yazi", {}),
				callback = function()
					require("lazy").load({ plugins = { plugin.name } })
					return true
				end,
			})
		end
	end,
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
	keys = {
		{ "<leader>e", "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
		{ "<leader>E", "<cmd>Yazi cwd<cr>", desc = "Open the file manager in nvim's working directory" },
	},
}
