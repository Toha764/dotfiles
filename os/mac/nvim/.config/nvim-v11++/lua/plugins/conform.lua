return {
  "stevearc/conform.nvim",
  config = function()
    vim.g.disable_autoformat = false

    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        rust = { "rustfmt" },
        javascript = { "prettier", stop_after_first = true },
        typescript = { "prettier", stop_after_first = true },
        go = { "gofumpt", "golines", "goimports-reviser" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        html = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },

      format_on_save = function()
        if vim.g.disable_autoformat then
          return
        end
        return {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      end,
    })
  end,
}

