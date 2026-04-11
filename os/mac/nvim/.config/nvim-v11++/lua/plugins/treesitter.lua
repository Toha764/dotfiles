--------------------------------------------------
-- Treesitter Configuration ***
--------------------------------------------------
return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufReadPost",
	build = ":TSUpdate",
	config = function()
		local status, configs = pcall(require, "nvim-treesitter.configs")
		if not status then
			return
		end

		configs.setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"python", -- Added for Python highlighting
				"javascript", -- Common languages
				"typescript",
				"go",
				"rust",
				"html",
				"css",
				"json",
				"bash",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false, -- Disable for better performance
			},
			indent = { enable = true }, -- Better indentation
		})
	end,
}
