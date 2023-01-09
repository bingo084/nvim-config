local vscode_status_ok, vscode = pcall(require, "vscode")
if not vscode_status_ok then
    vim.notify("vscode is not found!")
    return
end

-- vim.o.background = 'dark'

-- vscode.setup({
--     italic_comments = true,
-- })
