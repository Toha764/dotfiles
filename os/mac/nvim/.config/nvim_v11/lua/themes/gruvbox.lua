return {
	"ellisonleao/gruvbox.nvim",
	config = function()
		require("gruvbox").setup({
			contrast = "soft", -- "hard", "soft", or ""
			transparent_mode = true,
		})
	end,
}
