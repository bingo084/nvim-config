local icon_picker_status_ok, icon_picker = pcall(require, "icon-picker")
if not icon_picker_status_ok then
	vim.notify("icon-picker is not found!")
	return
end

icon_picker.setup({ disable_legacy_commands = true })
