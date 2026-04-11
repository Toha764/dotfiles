--------------------------------------------------
-- Main Init File
-- Modularized NeoVim Configuration — nvim 0.11
--------------------------------------------------
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Transparent bg before any plugin loads
vim.api.nvim_set_hl(0, "Normal",    { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC",  { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn",{ bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- Core (order matters: keymaps sets leader, options sets editor, lazy loads plugins)
require("core.keymaps")
require("core.options")
require("core.lazy")

-- UI (loaded after plugins so highlights land on top)
require("ui.statusline")
require("ui.tabline").setup()
require("ui.terminal").setup()
