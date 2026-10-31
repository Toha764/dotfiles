vim.opt.termguicolors = true

require("kanagawa").setup({
	theme = "wave",
	transparent = false,
	dimInactive = true,
	commentStyle = { italic = true },
	keywordStyle = { italic = false },
	statementStyle = { bold = true },
	typeStyle = { italic = false },
})
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = false,
	dim_inactive = { enabled = true },
})
require("tokyonight").setup({
	style = "night",
	transparent = false,
	dim_inactive = { enabled = true },
	styles = { comments = { italic = true }, keywords = { italic = false } },
})
require("gruvbox").setup({
	transparent_mode = false,
	italic = { strings = false, comments = true, operators = false, folds = false },
})

local state_file = vim.fn.stdpath("state") .. "/theme"
local default_theme = "kanagawa"
local light_themes = {
	kanagawa = "kanagawa-lotus",
	["catppuccin-mocha"] = "catppuccin-latte",
	["tokyonight-night"] = "tokyonight-day",
	["tokyonight-storm"] = "tokyonight-day",
	["tokyonight-moon"] = "tokyonight-day",
	gruvbox = "gruvbox",
}
local dark_themes = {
	["kanagawa-lotus"] = "kanagawa",
	["catppuccin-latte"] = "catppuccin-mocha",
	["tokyonight-day"] = "tokyonight-night",
	gruvbox = "gruvbox",
}

local function set_theme(name)
	vim.cmd.colorscheme(name)
	vim.fn.writefile({ name }, state_file)
end

local saved = vim.fn.filereadable(state_file) == 1 and vim.fn.readfile(state_file)[1] or nil
local ok = pcall(vim.cmd.colorscheme, saved or default_theme)
if not ok then
	vim.cmd.colorscheme(default_theme)
end

vim.keymap.set("n", "<leader>ut", function()
	require("fzf-lua").colorschemes({ actions = { ["default"] = function(selected)
		if selected and selected[1] then
			set_theme(selected[1])
		end
	end } })
end, { desc = "Choose theme" })

vim.keymap.set("n", "<leader>ub", function()
	local target = vim.o.background == "dark" and light_themes[vim.g.colors_name] or dark_themes[vim.g.colors_name]
	vim.o.background = vim.o.background == "dark" and "light" or "dark"
	set_theme(target or default_theme)
end, { desc = "Toggle light/dark theme" })
