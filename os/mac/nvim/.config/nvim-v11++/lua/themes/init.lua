local theme = "zenbones"

return {
	{
		"zenbones-theme/zenbones.nvim",
		dependencies = "rktjmp/lush.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme(theme)
		end,
	},
	{ "folke/tokyonight.nvim", lazy = false },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false },
	{ "rebelot/kanagawa.nvim", lazy = false },
	{ "EdenEast/nightfox.nvim", lazy = false },
	{ "rose-pine/neovim", name = "rose-pine", lazy = false },
}
