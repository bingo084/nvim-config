---@type LazySpec
return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason-lspconfig.nvim", opts = { automatic_installation = true } },
			{
				"williamboman/mason.nvim",
				config = true,
				keys = { { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer Info" } },
			},
		},
		config = function()
			local servers = {
				bashls = {},
				jsonls = { settings = { json = { schemas = require("schemastore").json.schemas() } } },
				lua_ls = {
					on_new_config = function(...) require("neodev.lsp").on_new_config(...) end,
					settings = { Lua = { completion = { callSnippet = "Replace" }, format = { enable = false } } },
				},
				yamlls = {},
				rust_analyzer = {},
				taplo = {},
				html = {},
				cssls = {},
				tsserver = {},
			}
			for _, lsp in ipairs(vim.tbl_keys(servers)) do
				servers[lsp]["capabilities"] = require("cmp_nvim_lsp").default_capabilities()
				require("lspconfig")[lsp].setup(servers[lsp])
			end

			local signs = { Error = "", Warn = "", Hint = "󱠂", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
			vim.diagnostic.config({ update_in_insert = true, float = { border = "rounded" } })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local function map(mode, key, action, desc)
						vim.keymap.set(mode, key, action, { buffer = ev.buf, desc = desc })
					end
					map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
					map("n", "gD", vim.lsp.buf.type_definition, "Goto Declaration")
					map("n", "gi", vim.lsp.buf.implementation, "Goto References And Implementation")
					map("n", "gr", vim.lsp.buf.references, "Goto References And Implementation")
					map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code Action")
					map("n", "K", vim.lsp.buf.hover, "Show Hover")
					map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature Help")
					local function scroll_map(key, row, desc)
						vim.keymap.set({ "n", "i", "s" }, key, function()
							if not require("noice.lsp").scroll(row) then
								return key
							end
						end, { silent = true, expr = true, buffer = ev.buf, desc = desc })
					end
					scroll_map("<A-d>", 4, "Scroll Down")
					scroll_map("<A-u>", -4, "Scroll Up")
				end,
			})
		end,
		event = { "BufReadPre", "BufNewFile" },
		keys = { { "<leader>li", "<cmd>LspInfo<CR>", desc = "Info" } },
	},
	{ "b0o/SchemaStore.nvim", lazy = true },
	{ "folke/neodev.nvim", lazy = true, opts = { lspconfig = false } },
	{ "mfussenegger/nvim-jdtls", lazy = true },
	{
		"nvimtools/none-ls.nvim",
		opts = function()
			local formatting = require("null-ls").builtins.formatting
			local diagnostics = require("null-ls").builtins.diagnostics
			return {
				sources = {
					formatting.stylua,
					formatting.google_java_format,
					formatting.yamlfmt,
					formatting.shfmt,
					formatting.markdownlint,
					diagnostics.markdownlint,
				},
			}
		end,
		keys = {
			{ "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "[F]ormat" },
			{ "<leader>ld", vim.diagnostic.open_float, desc = "[D]iagnostic" },
			{ "]d", vim.diagnostic.goto_next, desc = "Next [D]iagnostic" },
			{ "[d", vim.diagnostic.goto_prev, desc = "Prev [D]iagnostic" },
			{ "<leader>ll", vim.diagnostic.setloclist, desc = "[L]oclist" },
			{ "<leader>lq", vim.diagnostic.setqflist, desc = "[Q]flist" },
		},
		event = "VeryLazy",
	},
	{
		"jay-babu/mason-null-ls.nvim",
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim", "nvimtools/none-ls.nvim" },
		opts = { automatic_installation = true },
	},
	{
		"ThePrimeagen/refactoring.nvim",
		opts = {},
		keys = {
			{ "<leader>xf", ":Refactor extract ", mode = "x", desc = "e[X]tract [F]unction" },
			{ "<leader>xF", ":Refactor extract_to_file ", mode = "x", desc = "e[X]tract [F]unction to file" },
			{ "<leader>xv", ":Refactor extract_var ", mode = "x", desc = "e[X]tract [V]ariable" },
			{ "<leader>iv", ":Refactor inline_var", mode = { "n", "x" }, desc = "[I]nline [V]ariable" },
			{ "<leader>if", ":Refactor inline_func", desc = "[I]nline [F]unction" },
			{ "<leader>xb", ":Refactor extract_block", desc = "[E]xtract [B]lock" },
			{ "<leader>xB", ":Refactor extract_block_to_file", desc = "[E]xtract [B]lock to file" },
		},
	},
}
