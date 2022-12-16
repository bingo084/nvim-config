local status_ok, signature = pcall(require, "lsp_signature")
if not status_ok then
    vim.notify("lsp_signature is not found!")
    return
end

local icons = require "user.icons"

local cfg = {
    hint_prefix = icons.misc.Squirrel .. " ", -- Panda for parameter
}

signature.setup(cfg) -- no need to specify bufnr if you don't use toggle_key
