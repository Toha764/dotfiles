--------------------------------------------------
-- Theme Configuration *
--------------------------------------------------

return {
	"zenbones-theme/zenbones.nvim",
	dependencies = "rktjmp/lush.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.o.background = "dark"
		vim.cmd.colorscheme("zenbones")

		vim.api.nvim_set_hl(0, "NormalNC", { bg = "#0e0e0e" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "#000000" })
		vim.api.nvim_set_hl(0, "Normal", { bg = "#000000" })

		vim.api.nvim_set_hl(0, "@variable.lua", { fg = "#608786" }) -- greenish
		vim.api.nvim_set_hl(0, "@field.lua", { fg = "#61afef" })

		vim.api.nvim_set_hl(0, "@method.lua", { fg = "#98c379" })

		vim.api.nvim_set_hl(0, "Comment", { fg = "#5a5a5a", italic = true })
		vim.api.nvim_set_hl(0, "String", { fg = "#aa9988" }) -- orangish

		vim.api.nvim_set_hl(0, "Function", { fg = "#c0c0c0" })
		vim.api.nvim_set_hl(0, "Keyword", { fg = "#a8a8a8" })
		vim.api.nvim_set_hl(0, "Identifier", { fg = "#949494" }) -- ash

		-- Make tabline transparent and subtle
		vim.api.nvim_set_hl(0, "TabLine", {
			bg = "none",
			fg = "#666666",
		})
		vim.api.nvim_set_hl(0, "TabLineSel", {
			bg = "none",
			fg = "#aaaaaa",
			bold = true,
		})
		vim.api.nvim_set_hl(0, "TabLineFill", {
			bg = "none",
		})
	end,
}
