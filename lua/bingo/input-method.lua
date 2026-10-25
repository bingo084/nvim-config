-- Report editor context; Kitty owns the input-method policy and D-Bus calls.
if not vim.env.KITTY_WINDOW_ID then
	return
end

local group = vim.api.nvim_create_augroup("InputMethodContext", { clear = true })
local last, scheduled
local function report()
	if scheduled then
		return
	end
	scheduled = true
	vim.schedule(function()
		scheduled = false
		if #vim.api.nvim_list_uis() == 0 then
			return
		end
		local mode = vim.fn.mode()
		local tool = vim.b.sidekick_cli
		local context = mode == "t" and tool and tool.name == "codex" and "codex" or mode == "n" and "normal" or "other"
		if context ~= last then
			last = context
			vim.api.nvim_ui_send("\27]1337;SetUserVar=NVIM_MODE=" .. vim.base64.encode(context) .. "\7")
		end
	end)
end
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter", "BufEnter", "ModeChanged", "FocusGained", "VimResume" }, {
	group = group,
	callback = report,
})
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
	group = group,
	callback = function()
		last = nil
		vim.api.nvim_ui_send("\27]1337;SetUserVar=NVIM_MODE\7")
	end,
})
