local M = {}

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

M.setup = function()
	local signs = { Error = "", Warn = "", Hint = "󱠂", Info = "" }
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
end

local function lsp_keymaps(bufnr)
	local function map(mode, key, action, desc)
		vim.keymap.set(mode, key, action, { silent = true, buffer = bufnr, desc = desc })
	end
	map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Goto Definition")
	map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", "Goto Declaration")
	map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation")
	map("n", "gr", "<cmd>Telescope lsp_references<CR>", "Goto References")
	map("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Show Hover")
	map({ "n", "i" }, "<C-s>", function() vim.lsp.buf.signature_help() end, "Signature Help")
	local function scroll_map(key, row, desc)
		vim.keymap.set({ "n", "i", "s" }, key, function()
			if not require("noice.lsp").scroll(row) then
				return key
			end
		end, { silent = true, expr = true, buffer = bufnr, desc = desc })
	end
	scroll_map("<A-d>", 4, "Scroll Down")
	scroll_map("<A-u>", -4, "Scroll Up")

	map({ "n", "v" }, "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action")
	map("n", "<leader>ld", "<cmd>lua require('bingo.functions').toggle_diagnostics()<cr>", "Toggle Diagnostics")
	map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format")
	map(
		"n",
		"<leader>lF",
		"<cmd>lua require('bingo.plugins.lsp.handlers').toggle_format_on_save()<cr>",
		"Toggle Autoformat"
	)
	map("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({ border = 'rounded' })<CR>", "Next Diagnostic")
	map("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({ border = 'rounded' })<CR>", "Prev Diagnostic")
	map("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix")
	map("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help")
	map("n", "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type Definition")
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)

	if client.name == "jdtls" then
		vim.lsp.codelens.refresh()
		if JAVA_DAP_ACTIVE then
			require("jdtls").setup_dap({ hotcodereplace = "auto" })
			require("jdtls.dap").setup_dap_main_class_configs()
		end
	end
end

return M
