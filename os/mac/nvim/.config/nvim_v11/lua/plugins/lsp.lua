--------------------------------------------------
-- LSP System Configuration ***
--------------------------------------------------

return {
	-- LSPConfig: Configure LSP servers
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Floating window borders
			--------------------------------------------------
			local orig = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				return orig(contents, syntax, opts, ...)
			end

			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "●",
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				float = { border = "rounded" },
			})
			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
							},
						},
					},
				},
			})
			vim.lsp.config("ts_ls", { capabilities = capabilities })
			vim.lsp.config("pyright", { capabilities = capabilities })
			vim.lsp.config("gopls", { capabilities = capabilities })
			vim.lsp.config("clangd", { capabilities = capabilities })
			vim.lsp.config("html", { capabilities = capabilities })
			vim.lsp.config("css", { capabilities = capabilities })
			vim.lsp.config("intelephense", { capabilities = capabilities })

			vim.lsp.enable("lua_ls")
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("gopls")
			vim.lsp.enable("clangd")
			vim.lsp.enable("html")
			vim.lsp.enable("css")
			vim.lsp.enable("intelephense")
		end,
	},
}
