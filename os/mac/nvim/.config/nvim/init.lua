require("config.theme") -- colorscheme + transparency
require("config.options") -- vim.opt settings
require("config.keymaps") -- keybindings
require("config.statusline") -- custom statusline
require("config.autocmds") -- autocommands
require("config.plugins") -- vim.pack.add + packadd
require("config.alpha")
require("config.leet")
-- require("config.colorizer")

-- treesitter must come before lsp
require("config.treesitter")

-- require("config.nvimtree")
require("config.yazi")
require("config.fzf")
require("config.gitsigns")
require("config.lsp") -- LSP + blink.cmp + efm
require("config.terminal") -- floating terminal
require("config.mini")
require("config.markdown")
