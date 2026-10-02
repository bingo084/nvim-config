---@type LazySpec
return {
	"mrjones2014/smart-splits.nvim",
	dependencies = {
		"pogyomo/submode.nvim",
	},
	config = function()
		-- v2's cached Kitty pane ID does not change immediately after navigation (#451).
		local kitty = require("smart-splits.mux.kitty")
		local utils = require("smart-splits.utils")
		kitty.current_pane_id = function()
			local cmd = { "kitty", "@" }
			local password = vim.g.smart_splits_kitty_password or require("smart-splits.config").kitty_password or ""
			if #password > 0 then
				vim.list_extend(cmd, { "--password", password })
			end
			cmd[#cmd + 1] = "ls"
			local output, code = utils.system(cmd)
			if code ~= 0 or output == nil then
				return nil
			end
			local clients = vim.json.decode(output)
			local client = utils.tbl_find(clients, function(item) return item.is_active and item.is_focused end)
			if not client then
				return nil
			end
			local tab = utils.tbl_find(client.tabs, function(item)
				return (item.is_active or item.is_active_tab) and item.is_focused
			end)
			if not tab then
				return nil
			end
			local pane = utils.tbl_find(tab.windows, function(item)
				return (item.is_active or item.is_active_window) and item.is_focused
			end)
			return pane and pane.id
		end
		---@diagnostic disable-next-line: missing-fields
		require("smart-splits").setup({
			default_amount = 2,
			at_edge = function(ctx) ctx.split() end,
			cursor_follows_swapped_bufs = true,
		})
		local ss = require("smart-splits")
		local function create_resize_submode(modes)
			local function notify(msg)
				return function()
					vim.notify(msg, vim.log.levels.INFO, { id = "resize_mode", title = "Window Resize mode" })
				end
			end
			for _, mode in ipairs(modes) do
				require("submode").create("WinResize_" .. mode, {
					mode = mode,
					enter = "<A-r>",
					leave = { "<Esc>" },
					hook = {
						on_enter = notify("Use { h, j, k, l } to resize, = to reset, <ESC> to exit."),
						on_leave = notify("Exit window resize mode."),
					},
					default = function(register)
						register("h", ss.resize_left, { desc = "Resize left" })
						register("j", ss.resize_down, { desc = "Resize down" })
						register("k", ss.resize_up, { desc = "Resize up" })
						register("l", ss.resize_right, { desc = "Resize right" })
						register("=", "<cmd>wincmd =<CR>", { desc = "Reset size" })
					end,
				})
			end
		end
		local modes = { "n", "i", "t" }
		create_resize_submode(modes)
		vim.keymap.set(modes, "<A-h>", ss.move_cursor_left, { desc = "Move to left window" })
		vim.keymap.set(modes, "<A-j>", ss.move_cursor_down, { desc = "Move to down window" })
		vim.keymap.set(modes, "<A-k>", ss.move_cursor_up, { desc = "Move to up window" })
		vim.keymap.set(modes, "<A-l>", ss.move_cursor_right, { desc = "Move to right window" })
		vim.keymap.set(modes, "<A-S-h>", ss.swap_buf_left, { desc = "Swap window left" })
		vim.keymap.set(modes, "<A-S-j>", ss.swap_buf_down, { desc = "Swap window down" })
		vim.keymap.set(modes, "<A-S-k>", ss.swap_buf_up, { desc = "Swap window up" })
		vim.keymap.set(modes, "<A-S-l>", ss.swap_buf_right, { desc = "Swap window right" })
		vim.keymap.set(modes, "<A-w>", "<cmd>close<cr>", { desc = "Close window" })
	end,
	event = "VeryLazy",
}
