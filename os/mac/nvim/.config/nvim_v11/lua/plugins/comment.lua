--------------------------------------------------
-- Commenting Configuration
--------------------------------------------------

return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup()

		vim.keymap.set("n", "<leader>cc", function()
			require("Comment.api").toggle.linewise.current()
		end, { desc = "Toggle Comment Line" })

		vim.keymap.set("v", "<leader>cc", function()
			local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
			vim.api.nvim_feedkeys(esc, "nx", false)
			require("Comment.api").toggle.linewise(vim.fn.visualmode())
		end, { desc = "Toggle Comment Selection" })
	end,
}
