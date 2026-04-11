-----------------------------------------------------
-- Global Keymaps
--------------------------------------------------
--- quick jj to esc
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
--------------------------------------------------
-- LSP Keymaps ***
--------------------------------------------------
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename Symbol" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })

-- Leet Code
vim.keymap.set("n", "<leader>lr", "<cmd>Leet run<CR>", { desc = "Leet Run Code" })
vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<CR>", { desc = "Leet Submit" })

-- Code Formatter Toggle
vim.keymap.set("n", "<leader>cf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	print("Autoformat: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
end, { desc = "Toggle autoformat" })
