local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.setup = function()
	local diagnostics = require("bingo.icons").diagnostics
	local signs =
		{ Error = diagnostics.Error, Warn = diagnostics.Warn, Hint = diagnostics.Hint, Info = diagnostics.Info }
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

local function lsp_keymaps(bufnr)
	local function nmap(key, action, desc)
		vim.keymap.set("n", key, action, { noremap = true, silent = true, buffer = bufnr, desc = desc })
	end
	nmap("gd", "<cmd>Telescope lsp_definitions<CR>", "Goto Definition")
	nmap("gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration")
	nmap("gi", "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation")
	nmap("gr", "<cmd>Telescope lsp_references<CR>", "Goto References")
	nmap("K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Show Hover")
	nmap("<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action")
	nmap("<leader>ld", "<cmd>lua require('bingo.functions').toggle_diagnostics()<cr>", "Toggle Diagnostics")
	nmap("<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format")
	nmap(
		"<leader>lF",
		"<cmd>lua require('bingo.plugins.lsp.handlers').toggle_format_on_save()<cr>",
		"Toggle Autoformat"
	)
	nmap("<leader>lj", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", "Next Diagnostic")
	nmap("<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", "Prev Diagnostic")
	nmap("<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix")
	nmap("<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename")
	nmap("<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help")
	nmap("<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type Definition")
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	require("nvim-navic").attach(client, bufnr)

	if client.name == "jdtls" then
		vim.lsp.codelens.refresh()
		if JAVA_DAP_ACTIVE then
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs()
		end
	end
end

function M.enable_format_on_save()
	vim.cmd([[
    augroup format_on_save
      autocmd! 
      autocmd BufWritePre * lua vim.lsp.buf.format() 
    augroup end
  ]])
	vim.notify("Enabled format on save")
end

function M.disable_format_on_save()
	M.remove_augroup("format_on_save")
	vim.notify("Disabled format on save")
end

function M.toggle_format_on_save()
	if vim.fn.exists("#format_on_save#BufWritePre") == 0 then
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

return M
