local status_ok, schemastore = pcall(require, "schemastore")
if not status_ok then
	vim.notify("schemastore is not found!")
	return
end

return {
	settings = {
		json = {
			schemas = schemastore.json.schemas(),
			validate = { enable = true },
		},
	},
}
