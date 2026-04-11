-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
vim.pack.add({
	"https://www.github.com/lewis6991/gitsigns.nvim",
	"https://www.github.com/echasnovski/mini.nvim",
    "https://www.github.com/folke/which-key.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	-- "https://www.github.com/nvim-tree/nvim-tree.lua",
    "https://github.com/mikavilpas/yazi.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	-- Language Server Protocols
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
	"https://github.com/goolord/alpha-nvim",
    "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    -- "https://github.com/norcalli/nvim-colorizer.lua",

    -- Leetcode
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/kawre/leetcode.nvim",
})

local function packadd(name)
	vim.cmd("packadd " .. name)
end
-- packadd("nvim-treesitter")
packadd("yazi.nvim")
packadd("gitsigns.nvim")
packadd("mini.nvim")
packadd("which-key.nvim")
packadd("fzf-lua")
packadd("nvim-tree.lua")
-- packadd("nvim-colorizer.lua")
packadd("alpha-nvim")
packadd("render-markdown.nvim")
-- Leet
packadd("nui.nvim")
packadd("leetcode.nvim")
packadd("plenary.nvim")
-- LSP
packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("efmls-configs-nvim")
packadd("blink.cmp")
packadd("LuaSnip")
