vim.loader.enable()

require("config.options") -- vim.opt settings (before themes)
require("config.keymaps") -- keybindings
require("config.plugins") -- vim.pack.add + packadd
require("config.which-key") -- key hints + group names
require("config.theme") -- colorscheme + transparency

require("config.lualine")
require("config.autocmds") -- autocommands
require("config.terminal") -- floating terminal
require("config.mini") -- MiniTrailspace is used by the save hooks
require("config.runner") -- run current source file
require("config.alpha")
require("config.leet")
require("config.colorizer")

-- treesitter must come before lsp
require("config.treesitter")

require("config.yazi")
require("config.fzf")
require("config.gitsigns")
require("config.lsp") -- LSP + blink.cmp + efm
require("config.git") -- git pickers + lazygit
require("config.markdown")
require("config.smear-cursor") -- smear cursor effect

require("vision").setup({
  selection = {
    clear_after_send = true,
  },
  context = {
    current_file = true,
    cursor = false,
    current_line = false,
    diagnostics = false,
  },
})
