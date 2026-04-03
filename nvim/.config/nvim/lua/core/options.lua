--------------------------------------------------
-- Editor Settings & Options
--------------------------------------------------

-- makes the theme transparent
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	nested = true,
-- 	callback = function()
-- 		local groups = {
-- 			"Normal",
-- 			"NormalNC",
-- 			"NormalFloat",
-- 			"FloatBorder",
-- 			"SignColumn",
-- 			"EndOfBuffer",
-- 			"FoldColumn",
-- 			"LineNr",
-- 			"CursorLineNr",
-- 			"StatusLine",
-- 			"StatusLineNC",
-- 			"TabLine",
-- 			"TabLineFill",
-- 			"TabLineSel",
-- 			"Pmenu",
-- 			"PmenuSbar",
-- 		}
-- 		for _, g in ipairs(groups) do
-- 			vim.api.nvim_set_hl(0, g, { bg = "none", ctermbg = "none" })
-- 		end
-- 	end,
-- })

-- Behavior
vim.opt.clipboard = "unnamedplus"
vim.opt.backspace = "indent,eol,start"
vim.opt.iskeyword:append("-")
vim.opt.timeout = true
vim.opt.timeoutlen = 650
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winblend = 0
vim.opt.synmaxcol = 300
vim.opt.fillchars = { eob = " " }

-- Status Line
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.showmode = false

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Visuals
vim.opt.winborder = "rounded"

-- Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- ============================================================================
-- File Backup and Swap
-- ============================================================================

local state = vim.fn.stdpath("state")

vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupdir = state .. "/backup//"
vim.opt.undofile = true
vim.opt.undodir = state .. "/undo//"
vim.opt.updatetime = 300
vim.opt.autoread = true

vim.fn.mkdir(state .. "/undo", "p")
vim.fn.mkdir(state .. "/backup", "p")

-- ============================================================================
-- Text: Select / Move / Copy / Paste
-- ============================================================================

-- overwriting vim's stupid philosophy
vim.keymap.set({ "n", "v" }, "d", '"_d')
vim.keymap.set({ "n", "v" }, "D", '"_D')
vim.keymap.set({ "n", "v" }, "c", '"_c')
vim.keymap.set({ "n", "v" }, "C", '"_C')
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "X", '"_X')
vim.keymap.set({ "n", "v" }, "<leader>x", '"d', { desc = "Cut" })

vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })

-- move code block + indent
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ============================================================================
-- Navigation
-- ============================================================================

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Split creation
vim.keymap.set("n", "<leader>nv", "<cmd>vsplit<CR>", { silent = true })
vim.keymap.set("n", "<leader>nh", "<cmd>split<CR>", { silent = true })

-- Split movement
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true })

-- ============================================================================
-- Quality of Life Autocmds
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserOptions", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
	group = augroup,
	pattern = "*",
	command = "silent! wall",
})

vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})
