-- ============================================================================
-- PLUGIN CONFIGS — which-key
-- ============================================================================

require("which-key").setup({
	spec = {
		{ "<leader>b", group = "Buffers" },
		{ "<leader>d", group = "Diagnostics" },
		{ "<leader>f", group = "Find" },
		{ "<leader>g", group = "Git" },
		{ "<leader>h", group = "Git hunks" },
		{ "<leader>o", group = "LSP" },
		{ "<leader>p", group = "Paths and paste" },
		{ "<leader>r", group = "Run" },
		{ "<leader>s", group = "Splits" },
		{ "<leader>t", group = "Toggle" },
		{ "<leader>u", group = "UI" },
	},
})
