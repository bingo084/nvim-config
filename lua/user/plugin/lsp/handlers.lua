local M = {}

local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_status_ok then
    vim.notify("cmp_nvim_lsp is not found!")
    return
end

local which_key_status_ok, which_key = pcall(require, "which-key")
if not which_key_status_ok then
    vim.notify('which_key is not found!')
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
    local opts = {
        mode = "n",
        prefix = "",
        buffer = bufnr,
        silent = true,
        noremap = true,
        nowait = true,
    }
    local mappings = {
        g = {
            name = "Goto",
            d = { "<cmd>Telescope lsp_definitions<CR>", "Definition" },
            D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
            i = { "<cmd>Telescope lsp_implementations<CR>", "Implementation" },
            r = { "<cmd>Telescope lsp_references<CR>", "References" },
        },
        ["<leader>"] = {
            k = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Show Hover" },
            l = {
                name = "Lsp",
                a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
                f = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
                F = { "<cmd>LspToggleAutoFormat<cr>", "Toggle Autoformat" },
                j = { "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", "Next Diagnostic" },
                k = { "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", "Prev Diagnostic" },
                r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
                s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
                t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type Definition" },
            },
        }
    }
    which_key.register(mappings, opts)
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
      autocmd BufWritePre * lua vim.lsp.buf.format() 
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

vim.cmd [[ command! LspToggleAutoFormat execute 'lua require("user.plugin.lsp.handlers").toggle_format_on_save()' ]]

return M
