-- ============================================================================
-- GIT
-- ============================================================================
local fzf = require("fzf-lua")
local terminal = require("config.terminal")

vim.keymap.set("n", "<leader>gf", fzf.git_files, { desc = "Git files" })
vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Git commits" })
vim.keymap.set("n", "<leader>gb", fzf.git_branches, { desc = "Git branches" })
vim.keymap.set("n", "<leader>gg", function()
	terminal.run({ "lazygit" })
end, { desc = "Lazygit" })
