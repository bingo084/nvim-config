local M = {}

-- toggle option value
---@param values? {[1]:any, [2]:any}
function M.toggle_option(option, values)
	local function notify(msg) vim.notify(msg, vim.log.levels.INFO, { title = "Options" }) end
	if values then
		if vim.opt[option]:get() == values[1] then
			vim.opt[option] = values[2]
		else
			vim.opt[option] = values[1]
		end
		return notify("Set " .. option .. " to " .. tostring(vim.opt[option]:get()))
	end
	vim.opt[option] = not vim.opt[option]:get()
	local action = vim.opt[option]:get() and "Enabled " or "Disabled "
	notify(action .. option)
end

-- https://github.com/chrisgrieser/nvim-origami/blob/main/lua/origami/features/fold-keymaps.lua
local function normal(cmdStr) vim.cmd.normal({ cmdStr, bang = true }) end

---@return boolean
local function shouldCloseFold()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	local textBeforeCursor = vim.api.nvim_get_current_line():sub(1, col)
	local onIndentOrFirstNonBlank = textBeforeCursor:match("^%s*$")
	local firstChar = col == 0
	return onIndentOrFirstNonBlank or firstChar
end

-- `h` closes folds when at the beginning of a line.
function M.h()
	local count = vim.v.count1 -- saved as `normal` affects it
	for _ = 1, count, 1 do
		if shouldCloseFold() then
			local wasFolded = pcall(normal, "zc")
			if not wasFolded then
				normal("h")
			end
		else
			normal("h")
		end
	end
end

-- `l` on a folded line opens the fold.
function M.l()
	local count = vim.v.count1 -- saved as `normal` affects it
	for _ = 1, count, 1 do
		local isOnFold = vim.fn.foldclosed(".") > -1
		local action = isOnFold and "zo" or "l"
		pcall(normal, action)
	end
end

return M
