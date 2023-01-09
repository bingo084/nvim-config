local navic_status_ok, navic = pcall(require, "nvim-navic")
if not navic_status_ok then
	vim.notify("navic is not found!")
	return
end

navic.setup()
