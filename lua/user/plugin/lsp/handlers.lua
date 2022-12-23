local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    vim.notify("cmp_nvim_lsp is not found!")
    return
end
M.capabilities = cmp_nvim_lsp.default_capabilities()

M.setup = function()
    local diagnostics = require "user.icons".diagnostics
    local signs = { Error = diagnostics.Error, Warn = diagnostics.Warn, Hint = diagnostics.Hint, Info = diagnostics.Info }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    local config = {
        virtual_text = true,
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function attach_navic(client, bufnr)
    local status_ok, navic = pcall(require, "nvim-navic")
    if not status_ok then
        vim.notify("nvim-navic is not found!")
        return
    end
    navic.attach(client, bufnr)
end

local function lsp_keymaps(bufnr)
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.format({ async = true })' ]]
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ls', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>lk', function() vim.diagnostic.goto_prev({ border = "rounded" }) end, bufopts)
    vim.keymap.set('n', '<leader>lj', function() vim.diagnostic.goto_next({ border = "rounded" }) end, bufopts)
    vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format { async = true } end, bufopts)
end

M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)
    attach_navic(client, bufnr)

    if client.name == "jdtls" then
        vim.lsp.codelens.refresh()
        if JAVA_DAP_ACTIVE then
            require("jdtls").setup_dap { hotcodereplace = "auto" }
            require("jdtls.dap").setup_dap_main_class_configs()
        end
    end
end

function M.enable_format_on_save()
    vim.cmd [[
    augroup format_on_save
      autocmd! 
      autocmd BufWritePre * lua vim.lsp.buf.format({ async = true }) 
    augroup end
  ]]
    vim.notify "Enabled format on save"
end

function M.disable_format_on_save()
    M.remove_augroup "format_on_save"
    vim.notify "Disabled format on save"
end

function M.toggle_format_on_save()
    if vim.fn.exists "#format_on_save#BufWritePre" == 0 then
        M.enable_format_on_save()
    else
        M.disable_format_on_save()
    end
end

function M.remove_augroup(name)
    if vim.fn.exists("#" .. name) == 1 then
        vim.cmd("au! " .. name)
    end
end

vim.cmd [[ command! LspToggleAutoFormat execute 'lua require("user.lsp.handlers").toggle_format_on_save()' ]]

return M
