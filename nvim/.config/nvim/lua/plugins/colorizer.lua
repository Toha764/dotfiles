return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			"css",
			"scss",
			"html",
			"javascript",
			"typescript",
		}, {
			RGB = true, -- #RGB hex
			RRGGBB = true, -- #RRGGBB hex
			names = true, -- "red", "blue", etc.
			RRGGBBAA = true, -- #RRGGBBAA
			AARRGGBB = true, -- 0xAARRGGBB
			rgb_fn = true, -- rgb() / rgba()
			hsl_fn = true, -- hsl() / hsla()
			css = true, -- enable CSS features
			css_fn = true, -- enable CSS functions
		})
	end,
}
