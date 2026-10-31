-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================
local augroup = require("config.autocmds")

local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = "",
	Info = "",
}

local diagnostic_virtual_text = { prefix = "●", spacing = 4 }

vim.diagnostic.config({
	virtual_text = diagnostic_virtual_text,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

vim.keymap.set("n", "<leader>th", function()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
	vim.notify("Inlay hints " .. (enabled and "disabled" or "enabled"))
end, { desc = "Toggle inlay hints" })

vim.keymap.set("n", "<leader>tv", function()
	local enabled = vim.diagnostic.config().virtual_text ~= false
	if enabled then
		vim.diagnostic.config({ virtual_text = false })
	else
		vim.diagnostic.config({ virtual_text = diagnostic_virtual_text })
	end
	vim.notify("Diagnostic virtual text " .. (enabled and "disabled" or "enabled"))
end, { desc = "Toggle diagnostic virtual text" })

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf

	local function map(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, {
			noremap = true,
			silent = true,
			buffer = bufnr,
			desc = desc,
		})
	end

	-- ── Zed-aligned LSP keys ────────────────────────────────────────
	map("gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, "Go to definition") -- Zed: gd

	map("gD", vim.lsp.buf.declaration, "Go to declaration") -- Zed: gD

	map("gy", function()
		require("fzf-lua").lsp_typedefs()
	end, "Go to type definition") -- Zed: gy

	map("gI", function()
		require("fzf-lua").lsp_implementations()
	end, "Go to implementation") -- Zed: gI

	map("gA", function()
		require("fzf-lua").lsp_references()
	end, "Find references") -- Zed: gA

	map("gs", function()
		require("fzf-lua").lsp_document_symbols()
	end, "Document symbols") -- Zed: gs

	if client:supports_method("workspace/symbol", bufnr) then
		local workspace_symbols = function()
			require("fzf-lua").lsp_workspace_symbols()
		end
		map("gS", workspace_symbols, "Workspace symbols") -- Zed: gS
	end

	map("grn", vim.lsp.buf.rename, "Rename symbol") -- Zed: g r n (rename)
	map("g.", vim.lsp.buf.code_action, "Code action") -- Zed: g. (code action)

	map("gh", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, "Diagnostics for cursor") -- Zed: gh (hover diagnostic)

	-- ── Zed-aligned diagnostic navigation ──────────────────────────
	map("g]", function()
		vim.diagnostic.jump({ count = 1 })
	end, "Next diagnostic") -- Zed: g ] (next diagnostic)

	map("g[", function()
		vim.diagnostic.jump({ count = -1 })
	end, "Previous diagnostic") -- Zed: g [ (prev diagnostic)

	map("K", vim.lsp.buf.hover, "Hover documentation")

	if client:supports_method("textDocument/codeAction", bufnr) then
		map("<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
		end, "Organize imports")
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

require("luasnip.loaders.from_vscode").lazy_load()

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = { menu = { auto_show = true } },
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},

	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("pyright", {
	handlers = {
		["$/progress"] = function() end, -- suppress noisy progress notifications
	},
})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})

do
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	local prettier = require("efmls-configs.formatters.prettier")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	local cpplint = require("efmls-configs.linters.cpplint")
	local clangfmt = require("efmls-configs.formatters.clang_format")

	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")

	vim.lsp.config("efm", {
		filetypes = {
			"c",
			"cpp",
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"python",
			"sh",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c = { clangfmt, cpplint },
				go = { gofumpt, go_revive },
				cpp = { clangfmt, cpplint },
				css = { prettier },
				html = { prettier },
				javascript = { eslint_d, prettier },
				javascriptreact = { eslint_d, prettier },
				json = { eslint_d, prettier },
				jsonc = { eslint_d, prettier },
				lua = { luacheck, stylua },
				markdown = { prettier },
				python = { flake8, black },
				sh = { shellcheck, shfmt },
				typescript = { eslint_d, prettier },
				typescriptreact = { eslint_d, prettier },
				vue = { eslint_d, prettier },
				svelte = { eslint_d, prettier },
			},
		},
	})
end

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"bashls",
	"ts_ls",
	"gopls",
	"clangd",
	"efm",
})

vim.keymap.set("n", "<leader>ow", function()
	require("fzf-lua").lsp_workspace_symbols()
end, { desc = "Workspace symbols" })
