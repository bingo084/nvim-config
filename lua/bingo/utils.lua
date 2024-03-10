local M = {}

vim.cmd([[
  function Test()
    %SnipRun
    call feedkeys("\<esc>`.")
  endfunction
  function TestI()
    let b:caret = winsaveview()
    %SnipRun
    call winrestview(b:caret)
  endfunction
]])

function M.sniprun_enable()
	vim.cmd([[
    %SnipRun
    augroup _sniprun
     autocmd!
     autocmd TextChanged * call Test()
     autocmd TextChangedI * call TestI()
    augroup end
  ]])
	vim.notify("Enabled SnipRun")
end

function M.disable_sniprun()
	M.remove_augroup("_sniprun")
	vim.cmd([[
    SnipClose
    SnipTerminate
    ]])
	vim.notify("Disabled SnipRun")
end

function M.toggle_sniprun()
	if vim.fn.exists("#_sniprun#TextChanged") == 0 then
		M.sniprun_enable()
	else
		M.disable_sniprun()
	end
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

vim.cmd([[ command! SnipRunToggle execute 'lua require("bingo.functions").toggle_sniprun()' ]])

-- get length of current word
function M.get_word_length()
	local word = vim.fn.expand("<cword>")
	return #word
end

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

local diagnostics_active = true
function M.toggle_diagnostics()
	diagnostics_active = not diagnostics_active
	if diagnostics_active then
		vim.diagnostic.show()
	else
		vim.diagnostic.hide()
	end
end

function M.isempty(s) return s == nil or s == "" end

function M.get_buf_option(opt)
	local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

function M.map(mode, key, action, desc) vim.keymap.set(mode, key, action, { desc = desc }) end

return M
