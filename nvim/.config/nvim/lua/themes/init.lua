-- default
vim.cmd("colorscheme zenbones")

-- makes bg transparent
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local groups = {
			"Normal",
			"NormalNC",
			"NormalFloat",
			"FloatBorder",
			"SignColumn",
			"EndOfBuffer",
			"FoldColumn",
			"LineNr",
			"CursorLineNr",
			"StatusLine",
			"StatusLineNC",
			"TabLine",
			"TabLineFill",
			"TabLineSel",
			"Pmenu",
			"PmenuSbar",
		}
		for _, g in ipairs(groups) do
			vim.api.nvim_set_hl(0, g, { bg = "none", ctermbg = "none" })
		end
	end,
})

vim.cmd("doautocmd ColorScheme")
-- theme lists
return {
	require("themes.gruvbox"),
	require("themes.zenbones"),

	{ "folke/tokyonight.nvim", lazy = true },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true },
	{ "rebelot/kanagawa.nvim", lazy = true },
	{ "EdenEast/nightfox.nvim", lazy = true },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true },
}
