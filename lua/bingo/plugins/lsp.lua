---@type LazySpec
return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities({
				textDocument = { foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				} },
			})
			vim.lsp.config("*", { capabilities = capabilities })

			vim.diagnostic.config({
				update_in_insert = true,
				float = { border = "rounded" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "",
						[vim.diagnostic.severity.HINT] = "󱠂",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			vim.keymap.del({ "n", "x" }, "gra")
			vim.keymap.del("n", "gri")
			vim.keymap.del("n", "grn")
			vim.keymap.del("n", "grr")
			vim.keymap.del("n", "grt")
			vim.keymap.del("n", "gO")
			vim.keymap.del({ "i", "s" }, "<C-s>")

			local group = vim.api.nvim_create_augroup("UserLspConfig", {})
			vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
				group = group,
				callback = function(args)
					if next(vim.lsp.get_clients({ bufnr = args.buf })) then
						vim.lsp.codelens.refresh({ bufnr = args.buf })
					end
				end,
				desc = "Refresh code lens",
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = group,
				callback = function(ev)
					vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
					local function map(mode, key, action, desc)
						vim.keymap.set(mode, key, action, { buffer = ev.buf, desc = desc })
					end
					map("n", "gd", function() vim.lsp.buf.definition({ reuse_win = true }) end, "Goto [D]efinition")
					map("n", "gD", function() vim.lsp.buf.declaration({ reuse_win = true }) end, "Goto [D]eclaration")
					map(
						"n",
						"gi",
						function() vim.lsp.buf.implementation({ reuse_win = true }) end,
						"Goto [I]mplementation"
					)
					map("n", "gI", vim.lsp.buf.incoming_calls, "Goto [I]ncoming Calls")
					map("n", "gO", vim.lsp.buf.outgoing_calls, "Goto [O]utgoing Calls")
					map("n", "gr", function()
						vim.lsp.buf.references({ includeDeclaration = false }, {
							on_list = function(list)
								---@diagnostic disable-next-line: param-type-mismatch
								vim.fn.setqflist({}, " ", list)
								if #list.items == 1 then
									vim.cmd("cfirst")
								else
									vim.cmd("botright copen")
								end
							end,
						})
					end, "Goto [R]eferences")
					map(
						"n",
						"gy",
						function() vim.lsp.buf.type_definition({ reuse_win = true }) end,
						"Goto [D]eclaration"
					)
					map("n", "lc", vim.lsp.codelens.run, "Run Code Lens")
					map(
						{ "n", "v", "i" },
						"<A-Enter>",
						function() require("tiny-code-action").code_action({}) end,
						"Code Action"
					)
					map("n", "K", function()
						local winid = require("ufo").peekFoldedLinesUnderCursor()
						if not winid then
							vim.lsp.buf.hover()
						end
					end, "Show Hover")
					map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "Signature Help")
					local function scroll_map(key, row, desc)
						local cmp_scroll = row > 0 and require("blink-cmp").scroll_documentation_down
							or require("blink-cmp").scroll_documentation_up
						vim.keymap.set({ "n", "i", "s" }, key, function()
							if require("noice.lsp").scroll(row) then
								return
							end
							if not cmp_scroll(math.abs(row)) then
								return key
							end
						end, { silent = true, expr = true, buffer = ev.buf, desc = desc })
					end
					scroll_map("<A-d>", 4, "Documentation Scroll Down")
					scroll_map("<A-u>", -4, "Documentation Scroll Up")
				end,
			})
		end,
		event = { "BufReadPre", "BufNewFile" },
		keys = { { "<leader>li", "<cmd>LspInfo<CR>", desc = "Info" } },
	},
	{
		"mason-org/mason.nvim",
		opts = {},
		keys = { { "<leader>lI", "<cmd>Mason<cr>", desc = "Installer" } },
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"bashls",
				"cssls",
				"gopls",
				"html",
				"hyprls",
				"jdtls",
				"jsonls",
				"lua_ls",
				"postgres_lsp",
				"rust_analyzer",
				"taplo",
				"ts_ls",
				"vue_ls",
				"yamlls",
			},
		},
		event = { "BufReadPre", "BufNewFile" },
	},
	{ "b0o/SchemaStore.nvim", lazy = true },
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "lazy.nvim", words = { "LazySpec" } },
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "mfussenegger/nvim-jdtls", version = false, lazy = true },
	{
		"ThePrimeagen/refactoring.nvim",
		opts = {},
		keys = {
			{ "<leader>xf", ":Refactor extract ", mode = "x", desc = "Function" },
			{ "<leader>xF", ":Refactor extract_to_file ", mode = "x", desc = "Function to file" },
			{ "<leader>xv", ":Refactor extract_var ", mode = "x", desc = "Variable" },
			{ "<leader>iv", ":Refactor inline_var", mode = { "n", "x" }, desc = "Variable" },
			{ "<leader>if", ":Refactor inline_func", desc = "Function" },
			{ "<leader>xb", ":Refactor extract_block", desc = "Block" },
			{ "<leader>xB", ":Refactor extract_block_to_file", desc = "Block to file" },
		},
	},
}
