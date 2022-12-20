local navic_status_ok, navic = pcall(require, "nvim-navic")
if not navic_status_ok then
    vim.notify("navic is not found!")
    return
end

navic.setup {
    highlight = true,
}
vim.api.nvim_set_hl(0, "NavicIconsFile", { link = "CmpItemKindFile" })
vim.api.nvim_set_hl(0, "NavicIconsModule", { link = "CmpItemKindModule" })
vim.api.nvim_set_hl(0, "NavicIconsClass", { link = "CmpItemKindClass" })
vim.api.nvim_set_hl(0, "NavicIconsMethod", { link = "CmpItemKindMethod" })
vim.api.nvim_set_hl(0, "NavicIconsProperty", { link = "CmpItemKindProperty" })
vim.api.nvim_set_hl(0, "NavicIconsField", { link = "CmpItemKindField" })
vim.api.nvim_set_hl(0, "NavicIconsConstructor", { link = "CmpItemKindConstructor" })
vim.api.nvim_set_hl(0, "NavicIconsEnum", { link = "CmpItemKindEnum" })
vim.api.nvim_set_hl(0, "NavicIconsInterface", { link = "CmpItemKindInterface" })
vim.api.nvim_set_hl(0, "NavicIconsFunction", { link = "CmpItemKindFunction" })
vim.api.nvim_set_hl(0, "NavicIconsVariable", { link = "CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "NavicIconsConstant", { link = "CmpItemKindConstant" })
vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { link = "CmpItemKindEnumMember" })
vim.api.nvim_set_hl(0, "NavicIconsStruct", { link = "CmpItemKindStruct" })
vim.api.nvim_set_hl(0, "NavicIconsEvent", { link = "CmpItemKindEvent" })
vim.api.nvim_set_hl(0, "NavicIconsOperator", { link = "CmpItemKindOperator" })
vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { link = "CmpItemKindTypeParameter" })
vim.api.nvim_set_hl(0, "NavicText", { link = "CmpItemKindText" })
