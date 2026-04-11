--------------------------------------------------
-- Main Init File
-- Modularized NeoVim Configuration
--------------------------------------------------
vim.opt.termguicolors = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Transparent bg before any plugin loads
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

-- Core
require("core.keymaps")
require("core.lazy")
require("core.options")

-- UI modules
require("ui.tabline").setup()
require("ui.terminal").setup()
