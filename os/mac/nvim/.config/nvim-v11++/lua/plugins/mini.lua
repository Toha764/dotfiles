--------------------------------------------------
-- mini.nvim — curated modules (from nvim-lite)
-- Excluded: mini.comment (Comment.nvim handles it)
--           mini.pairs   (nvim-autopairs handles it)
--           mini.move    (A-j/k keymaps handle it)
--------------------------------------------------

return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		-- Enhanced text objects: cin), da", via, etc.
		require("mini.ai").setup({})

		-- Surround: sa (add), sd (delete), sr (replace)
		-- e.g. saiw" wraps word in quotes, sd" removes surrounding quotes
		require("mini.surround").setup({})

		-- Highlight word under cursor across the buffer
		require("mini.cursorword").setup({})

		-- Animate indent scope lines
		require("mini.indentscope").setup({
			symbol = "│",
			options = { try_as_border = true },
		})

		-- Highlight + auto-remove trailing whitespace
		require("mini.trailspace").setup({})

		-- Smart buffer removal (keeps window layout)
		require("mini.bufremove").setup({})
		vim.keymap.set("n", "<leader>bd", function()
			require("mini.bufremove").delete(0, false)
		end, { desc = "Delete buffer (keep layout)" })

		-- Better notifications (replaces vim.notify)
		require("mini.notify").setup({})

		-- Icon provider used by other plugins
		require("mini.icons").setup({})

		-- Neovim starter / dashboard (optional — disable if using alpha)
		-- require("mini.starter").setup({})
	end,
}
