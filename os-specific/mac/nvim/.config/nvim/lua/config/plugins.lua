-- ============================================================================
-- PLUGINS
-- ============================================================================
vim.pack.add({
	-- UI
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },

	-- Themes
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },

	-- Core
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/folke/which-key.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/mikavilpas/yazi.nvim" },

	-- Treesitter
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},

	-- LSP
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/creativenull/efmls-configs-nvim" },
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },

	-- Misc
	{ src = "https://github.com/goolord/alpha-nvim" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/norcalli/nvim-colorizer.lua" },

	-- Leetcode
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/kawre/leetcode.nvim" },
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },

    -- test
    { src =  "https://github.com/azorng/vision.nvim"},
})

-- ============================================================================
-- LOAD PLUGINS
-- ============================================================================

local function packadd(name)
	vim.cmd("packadd " .. name)
end

packadd("nvim-web-devicons")
packadd("lualine.nvim")

packadd("kanagawa.nvim")
packadd("catppuccin")
packadd("tokyonight.nvim")
packadd("gruvbox.nvim")

packadd("gitsigns.nvim")
packadd("mini.nvim")
packadd("which-key.nvim")
packadd("fzf-lua")
packadd("yazi.nvim")

packadd("nvim-treesitter")

packadd("alpha-nvim")
packadd("render-markdown.nvim")
packadd("plenary.nvim")
packadd("nui.nvim")
packadd("leetcode.nvim")
packadd("nvim-colorizer.lua")

packadd("nvim-lspconfig")
packadd("mason.nvim")
packadd("efmls-configs-nvim")
packadd("blink.cmp")
packadd("LuaSnip")
packadd("friendly-snippets")
packadd("smear-cursor.nvim")

-- extra
packadd("vision.nvim")
