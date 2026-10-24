if vim.fn.executable("busctl") ~= 1 then
	return
end

local function ascii_mode()
	if vim.fn.mode() == "n" then
		return true
	end
end

local generation, busy, pending, scheduled, focused = 0, false, false, false, true
local apply
local function call(method, args, callback)
	local command =
		{ "busctl", "--user", "--timeout=1", "call", "org.fcitx.Fcitx5", "/rime", "org.fcitx.Fcitx.Rime1", method }
	vim.list_extend(command, args)
	vim.system(command, { text = true, timeout = 1000 }, vim.schedule_wrap(callback))
end
local function warn(result)
	local message = vim.trim(result.stderr or "")
	vim.notify_once("Rime input method: " .. (message ~= "" and message or "D-Bus request failed"), vim.log.levels.WARN)
end
local function finish()
	busy = false
	if pending then
		apply()
	end
end
apply = function()
	if busy or not pending then
		return
	end
	pending = false
	local target = ascii_mode()
	if not focused or target == nil or #vim.api.nvim_list_uis() == 0 then
		return
	end
	busy = true
	local request = generation
	call("IsAsciiMode", {}, function(result)
		-- A newer window/mode event supersedes this query.
		if request ~= generation or not focused then
			finish()
			return
		end
		if result.code ~= 0 then
			warn(result)
			finish()
			return
		end
		local current = vim.trim(result.stdout or "")
		-- Avoid showing Fcitx's switch popup when the state already matches.
		if current ~= "b true" and current ~= "b false" or (current == "b true") == target then
			finish()
			return
		end
		call("SetAsciiMode", { "b", tostring(target) }, function(updated)
			if updated.code ~= 0 and focused then
				warn(updated)
			end
			finish()
		end)
	end)
end

local function refresh()
	generation = generation + 1
	pending = true
	if scheduled then
		return
	end
	scheduled = true
	-- Let window and mode changes settle before checking the active context.
	vim.schedule(function()
		scheduled = false
		apply()
	end)
end

local group = vim.api.nvim_create_augroup("InputMethod", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufEnter", "ModeChanged", "FocusGained" }, {
	group = group,
	callback = function(args)
		if args.event == "FocusGained" then
			focused = true
		end
		refresh()
	end,
	desc = "Use English in Normal mode",
})
vim.api.nvim_create_autocmd("FocusLost", {
	group = group,
	callback = function()
		focused = false
		generation = generation + 1
		pending = false
	end,
})
