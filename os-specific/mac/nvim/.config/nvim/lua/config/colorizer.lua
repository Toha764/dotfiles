-- nvim-colorizer still calls vim.tbl_flatten (deprecated in Nvim 0.12).
-- Silence deprecation warnings only while this plugin sets up.
local deprecate = vim.deprecate
vim.deprecate = function() end
require("colorizer").setup({
	css = {
		rgb_fn = true, -- rgb(255, 0, 0)
		hsl_fn = true, -- hsl(120, 100%, 50%)
	},
	html = { mode = "foreground" },
	"javascript",
	"typescript",
}, {
	mode = "background", -- color as background
})
vim.deprecate = deprecate
