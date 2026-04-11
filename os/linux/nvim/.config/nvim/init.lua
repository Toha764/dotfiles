-- ============================================================================
-- init.lua — loader only, all config lives in lua/config/
-- ============================================================================

require("os.mac.nvim.config.nvim.lua.config.theme")      -- colorscheme + transparency
require("os.mac.nvim.config.nvim.lua.config.options")    -- vim.opt settings
require("os.mac.nvim.config.nvim.lua.config.keymaps")    -- keybindings (sets mapleader first)
require("os.mac.nvim.config.nvim.lua.config.statusline") -- custom statusline
require("os.mac.nvim.config.nvim.lua.config.autocmds")   -- autocommands (returns augroup)
require("os.mac.nvim.config.nvim.lua.config.plugins")    -- vim.pack.add + packadd
-- plugin configs (order matters: treesitter before lsp)
require("os.mac.nvim.config.nvim.lua.config.treesitter")
require("config.nvimtree")
require("os.mac.nvim.config.nvim.lua.config.fzf")
require("os.mac.nvim.config.nvim.lua.config.mini")
require("os.mac.nvim.config.nvim.lua.config.gitsigns")
require("os.mac.nvim.config.nvim.lua.config.lsp")        -- LSP + blink.cmp + efm (needs augroup)
require("os.mac.nvim.config.nvim.lua.config.terminal")   -- floating terminal (needs augroup)
