-------------------------------------
-- Mason: LSP servers + tools auto-install
-------------------------------------

return {
	{
		"williamboman/mason.nvim",
		build  = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		event        = { "BufReadPre" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", "pyright", "ts_ls",
					"gopls",  "clangd",  "html",
					"cssls",  "intelephense", "bashls",
				},
				automatic_installation = true,
			})
		end,
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- Formatters
					"stylua", "black", "prettier",
					"clang-format", "gofumpt", "shfmt",
					-- Linters
					"eslint_d", "flake8", "shellcheck",
				},
				run_on_start = true,
				auto_update  = false,
			})
		end,
	},
}
