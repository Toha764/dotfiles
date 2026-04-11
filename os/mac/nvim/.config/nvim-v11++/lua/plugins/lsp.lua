--------------------------------------------------
-- LSP System Configuration — nvim 0.11
-- Pattern: LspAttach autocmd (from nvim-lite)
-- Search: Telescope (from nvim-mac)
-- Capabilities: nvim-cmp
--------------------------------------------------

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Rounded borders on all floating LSP windows
			local orig = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts         = opts or {}
				opts.border  = opts.border or "rounded"
				return orig(contents, syntax, opts, ...)
			end

			-- Diagnostic display
			local signs = { Error = " ", Warn = " ", Hint = "", Info = "" }
			vim.diagnostic.config({
				virtual_text   = { prefix = "●", spacing = 4 },
				signs          = {
					text = {
						[vim.diagnostic.severity.ERROR] = signs.Error,
						[vim.diagnostic.severity.WARN]  = signs.Warn,
						[vim.diagnostic.severity.INFO]  = signs.Info,
						[vim.diagnostic.severity.HINT]  = signs.Hint,
					},
				},
				underline         = true,
				update_in_insert  = false,
				severity_sort     = true,
				float             = {
					border    = "rounded",
					source    = "always",
					header    = "",
					prefix    = "",
					focusable = false,
					style     = "minimal",
				},
			})

			-- ──────────────────────────────────────────────────────────────
			-- Buffer-local keymaps via LspAttach (from nvim-lite)
			-- ──────────────────────────────────────────────────────────────
			local augroup = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })

			vim.api.nvim_create_autocmd("LspAttach", {
				group    = augroup,
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then return end

					local bufnr = ev.buf
					local opts  = { noremap = true, silent = true, buffer = bufnr }

					-- Go to definition (telescope — fuzzy pick if multiple)
					vim.keymap.set("n", "<leader>gd", function()
						require("telescope.builtin").lsp_definitions({ jump_type = "never" })
					end, opts)
					vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts) -- direct jump
					vim.keymap.set("n", "<leader>gi", function()
						require("telescope.builtin").lsp_implementations()
					end, opts)
					vim.keymap.set("n", "<leader>gr", function()
						require("telescope.builtin").lsp_references()
					end, opts)
					vim.keymap.set("n", "<leader>gt", function()
						require("telescope.builtin").lsp_type_definitions()
					end, opts)

					-- open definition in vertical split
					vim.keymap.set("n", "<leader>gS", function()
						vim.cmd("vsplit")
						vim.lsp.buf.definition()
					end, opts)

					-- code actions / rename
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

					-- hover / signature help
					vim.keymap.set("n", "K",         vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>K",  vim.lsp.buf.signature_help, opts)

					-- diagnostics
					vim.keymap.set("n", "<leader>D", function()
						vim.diagnostic.open_float({ scope = "line" })
					end, opts)
					vim.keymap.set("n", "<leader>d", function()
						vim.diagnostic.open_float({ scope = "cursor" })
					end, opts)
					vim.keymap.set("n", "<leader>nd", function()
						vim.diagnostic.jump({ count = 1 })
					end, opts)
					vim.keymap.set("n", "<leader>pd", function()
						vim.diagnostic.jump({ count = -1 })
					end, opts)

					-- document / workspace symbols
					vim.keymap.set("n", "<leader>fs", function()
						require("telescope.builtin").lsp_document_symbols()
					end, opts)
					vim.keymap.set("n", "<leader>fw", function()
						require("telescope.builtin").lsp_workspace_symbols()
					end, opts)

					-- organise imports + format (when server supports it)
					if client:supports_method("textDocument/codeAction", bufnr) then
						vim.keymap.set("n", "<leader>oi", function()
							vim.lsp.buf.code_action({
								context = { only = { "source.organizeImports" }, diagnostics = {} },
								apply   = true,
								bufnr   = bufnr,
							})
							vim.defer_fn(function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end, 50)
						end, opts)
					end
				end,
			})

			-- ──────────────────────────────────────────────────────────────
			-- Server configurations
			-- ──────────────────────────────────────────────────────────────

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace   = {
							checkThirdParty = false,
							library         = { vim.env.VIMRUNTIME },
						},
						telemetry = { enable = false },
					},
				},
			})
			vim.lsp.config("ts_ls",       { capabilities = capabilities })
			vim.lsp.config("pyright",     { capabilities = capabilities })
			vim.lsp.config("gopls",       { capabilities = capabilities })
			vim.lsp.config("clangd",      { capabilities = capabilities })
			vim.lsp.config("html",        { capabilities = capabilities })
			vim.lsp.config("cssls",       { capabilities = capabilities })
			vim.lsp.config("intelephense",{ capabilities = capabilities })
			vim.lsp.config("bashls",      { capabilities = capabilities })

			vim.lsp.enable({
				"lua_ls", "ts_ls", "pyright", "gopls",
				"clangd", "html",  "cssls",   "intelephense", "bashls",
			})
		end,
	},
}
