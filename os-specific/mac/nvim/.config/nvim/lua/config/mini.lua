-- ============================================================================
-- PLUGIN CONFIGS — mini.nvim
-- ============================================================================

require("mini.comment").setup({})
require("mini.move").setup({})
require("mini.surround").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.notify").setup({})
require("mini.icons").setup({})
require("mini.ai").setup({
	mappings = {
		goto_left = "", -- keep g[ free for LSP diagnostics (Zed-style)
		goto_right = "", -- keep g] free for LSP diagnostics (Zed-style)
	},
})
