-------------------------------------
-- Installs Masson LSP, Formatters
-------------------------------------

return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					-- LSP servers
					"lua_ls",
					"pyright",
					"ts_ls",
					"gopls",
					"rust_analyzer",
					"clangd",
					"intelephense",
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
					-- FORMATTERS
					"black",
					"stylua",
					"prettier",
					"rustfmt",
					"clang-format",
					"gofumpt",
					"php-cs-fixer",

					-- LINTERS
					"eslint_d",
					"flake8",
				},
				run_on_start = true,
				auto_update = false,
			})
		end,
	},
}
