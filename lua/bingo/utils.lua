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

return M
