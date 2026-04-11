--------------------------------------------------
-- Editor Settings & Options — nvim 0.11
-- Reference: nvim-lite (primary) + nvim-mac
--------------------------------------------------

-- ============================================================================
-- Behaviour
-- ============================================================================

vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.backspace = "indent,eol,start" -- better backspace
vim.opt.iskeyword:append("-") -- treat - as part of word
vim.opt.mouse = "a" -- enable mouse
vim.opt.encoding = "utf-8"
vim.opt.hidden = true -- allow unsaved background buffers
vim.opt.errorbells = false
vim.opt.autochdir = false
vim.opt.autoread = true -- auto-reload externally changed files
vim.opt.autowrite = false -- do not auto-save
vim.opt.modifiable = true

-- timeout
vim.opt.timeout = true
vim.opt.timeoutlen = 500 -- leader sequence wait
vim.opt.ttimeoutlen = 0 -- key code timeout

-- ============================================================================
-- Visuals
-- ============================================================================

vim.opt.termguicolors = true
vim.opt.number = true -- absolute line numbers
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.signcolumn = "yes" -- always show sign column
vim.opt.wrap = false -- no line wrapping by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 cols left/right
vim.opt.colorcolumn = "100" -- ruler at 100
vim.opt.showmatch = true -- highlight matching brackets
vim.opt.showmode = false -- mode shown in statusline instead
vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines
vim.opt.synmaxcol = 300
vim.opt.winborder = "rounded" -- global floating window border (nvim 0.11)

-- ============================================================================
-- Statusline / Command area
-- ============================================================================

vim.opt.laststatus = 3 -- global statusline
vim.opt.cmdheight = 0 -- hide command line when not in use (nvim 0.11)

-- ============================================================================
-- Indentation
-- ============================================================================

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- ============================================================================
-- Search
-- ============================================================================

vim.opt.ignorecase = true -- case-insensitive by default
vim.opt.smartcase = true -- case-sensitive when uppercase present
vim.opt.hlsearch = false -- don't highlight after search (use <leader>c to flash)
vim.opt.incsearch = true -- show matches as you type

-- ============================================================================
-- Completion popup
-- ============================================================================

vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.pumheight = 10 -- max popup height
vim.opt.pumblend = 10 -- popup transparency
vim.opt.winblend = 0 -- floating window transparency

-- ============================================================================
-- Folding (treesitter-based, starts open)
-- ============================================================================

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- ============================================================================
-- Splits
-- ============================================================================

vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right

-- ============================================================================
-- Wildmenu / Diff
-- ============================================================================

vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.diffopt:append("linematch:60")

-- ============================================================================
-- Undo / Backup / Swap — stored in XDG state dir
-- ============================================================================

local state = vim.fn.stdpath("state")

vim.fn.mkdir(state .. "/undo", "p")
vim.fn.mkdir(state .. "/backup", "p")

vim.opt.swapfile = false
vim.opt.backup = true
vim.opt.backupdir = state .. "/backup//"
vim.opt.undofile = true
vim.opt.undodir = state .. "/undo//"
vim.opt.updatetime = 300

-- ============================================================================
-- Cursor style & blinking
-- ============================================================================

vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,"
	.. "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,"
	.. "sm:block-blinkwait175-blinkoff150-blinkon175"

-- ============================================================================
-- Autocmds
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserOptions", { clear = true })

-- auto-save on focus loss / leaving insert mode (great for flow)
vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "BufLeave" }, {
	group = augroup,
	pattern = "*",
	command = "silent! wall",
})

-- equalize window sizes on terminal resize
vim.api.nvim_create_autocmd("VimResized", {
	group = augroup,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- flash yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- return to last cursor position on open
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then
			return
		end -- skip diff mode
		local last_pos = vim.api.nvim_buf_get_mark(0, '"')
		local last_line = vim.api.nvim_buf_line_count(0)
		local row = last_pos[1]
		if row >= 1 and row <= last_line then
			pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
		end
	end,
})

-- wrap, linebreak, spell on prose files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- clean up terminal buffers when process exits successfully
vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function()
		if vim.v.event.status == 0 then
			vim.api.nvim_buf_delete(0, {})
		end
	end,
})

-- no line numbers or signs in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})
