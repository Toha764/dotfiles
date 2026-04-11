--------------------------------------------------
-- Git Integration (Gitsigns)
-- Full config + keymaps from nvim-lite
--------------------------------------------------

return {
	"lewis6991/gitsigns.nvim",
	config = function()
		require("os.mac.nvim.config.nvim.lua.config.gitsigns").setup({
			signs = {
				add          = { text = "\u{2590}" }, -- ▐
				change       = { text = "\u{2590}" },
				delete       = { text = "\u{2590}" },
				topdelete    = { text = "\u{25e6}" }, -- ◦
				changedelete = { text = "\u{25cf}" }, -- ●
				untracked    = { text = "\u{25cb}" }, -- ○
			},
			signcolumn          = true,
			current_line_blame  = false,
		})

		-- hunk navigation
		vim.keymap.set("n", "]h", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").next_hunk() end,                    { desc = "Next git hunk" })
		vim.keymap.set("n", "[h", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").prev_hunk() end,                    { desc = "Prev git hunk" })

		-- hunk operations
		vim.keymap.set("n", "<leader>hs", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").stage_hunk() end,           { desc = "Stage hunk" })
		vim.keymap.set("n", "<leader>hr", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").reset_hunk() end,           { desc = "Reset hunk" })
		vim.keymap.set("n", "<leader>hp", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").preview_hunk() end,         { desc = "Preview hunk" })
		vim.keymap.set("n", "<leader>hb", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
		vim.keymap.set("n", "<leader>hB", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").toggle_current_line_blame() end, { desc = "Toggle inline blame" })
		vim.keymap.set("n", "<leader>hd", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").diffthis() end,             { desc = "Diff this" })
		vim.keymap.set("n", "<leader>hD", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").diffthis("~") end,          { desc = "Diff this ~" })
		vim.keymap.set("n", "<leader>hu", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").undo_stage_hunk() end,      { desc = "Undo stage hunk" })
		vim.keymap.set("n", "<leader>hS", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").stage_buffer() end,         { desc = "Stage buffer" })
		vim.keymap.set("n", "<leader>hR", function() require("os.mac.nvim.config.nvim.lua.config.gitsigns").reset_buffer() end,         { desc = "Reset buffer" })

		-- visual mode hunk operations
		vim.keymap.set("v", "<leader>hs", function()
			require("os.mac.nvim.config.nvim.lua.config.gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk (visual)" })
		vim.keymap.set("v", "<leader>hr", function()
			require("os.mac.nvim.config.nvim.lua.config.gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset hunk (visual)" })
	end,
}
