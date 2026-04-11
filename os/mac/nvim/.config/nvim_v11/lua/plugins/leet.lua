return {
	"kawre/leetcode.nvim",
	cmd = { "Leet" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("leetcode").setup({
			lang = "javascript", -- or "cpp", "javascript", etc.
		})
	end,
}
