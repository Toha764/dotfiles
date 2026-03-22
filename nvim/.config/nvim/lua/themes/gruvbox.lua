return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000, -- load before other UI plugins
	config = function()
		require("gruvbox").setup({
			contrast = "hard", -- "hard", "soft", or ""
			transparent_mode = false,
		})

		vim.cmd("colorscheme gruvbox")
	end,
}
