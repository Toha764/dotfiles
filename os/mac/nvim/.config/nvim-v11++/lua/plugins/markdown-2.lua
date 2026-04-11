return {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	build = "cd app && npm install",
	config = function()
		vim.keymap.set("n", "<leader>mdn", ":MarkdownPreview<CR>")
		vim.keymap.set("n", "<leader>mds", ":MarkdownPreviewStop<CR>")
	end,
}
