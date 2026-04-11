--------------------------------------------------
-- Keymaps
-- Reference: nvim-lite (primary) + nvim-mac
--------------------------------------------------

-- quick jj to esc
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-- ============================================================================
-- Text: Select / Copy / Paste / Delete
-- NOTE: d/D/c/C are NOT overridden — they work as vanilla vim.
--       Use <leader>x to delete without polluting the yank register.
-- ============================================================================

vim.keymap.set("n", "<C-a>", "ggVG\"+y", { desc = "Select all + copy to clipboard" })
vim.keymap.set("x", "<leader>p", '"_dP',  { desc = "Paste without yanking selection" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

-- ============================================================================
-- Navigation
-- ============================================================================

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- centered search / scroll
vim.keymap.set("n", "n",      "nzzzv",    { desc = "Next search result (centered)" })
vim.keymap.set("n", "N",      "Nzzzv",    { desc = "Prev search result (centered)" })
vim.keymap.set("n", "<C-d>",  "<C-d>zz",  { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>",  "<C-u>zz",  { desc = "Half page up (centered)" })

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- splits
vim.keymap.set("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", "<cmd>split<CR>",  { desc = "Split horizontally" })

-- ============================================================================
-- Editing
-- ============================================================================

-- move lines / blocks
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==",        { silent = true, desc = "Move line up" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==",        { silent = true, desc = "Move line down" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv",    { silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv",    { silent = true, desc = "Move selection up" })

-- indent without leaving visual mode
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- join lines without moving cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- ============================================================================
-- Utilities
-- ============================================================================

vim.keymap.set("n", "<leader>pa", function() -- copy + print file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

-- Code formatter toggle (conform)
vim.keymap.set("n", "<leader>cf", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	print("Autoformat: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
end, { desc = "Toggle autoformat" })

-- ============================================================================
-- LSP (global — buffer-local LSP keymaps live in plugins/lsp.lua)
-- ============================================================================

vim.keymap.set("n", "<leader>q",  function() vim.diagnostic.setloclist({ open = true }) end, { desc = "Diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- ============================================================================
-- Leet Code
-- ============================================================================

vim.keymap.set("n", "<leader>lr", "<cmd>Leet run<CR>",    { desc = "Leet Run Code" })
vim.keymap.set("n", "<leader>ls", "<cmd>Leet submit<CR>", { desc = "Leet Submit" })
