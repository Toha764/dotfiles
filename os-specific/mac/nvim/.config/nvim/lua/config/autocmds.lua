-- ============================================================================
-- AUTOCMDS
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.g.autoformat = false

-- Format on save (ONLY real file buffers, ONLY when efm is attached)
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua",
		"*.py",
		"*.go",
		"*.js",
		"*.jsx",
		"*.ts",
		"*.tsx",
		"*.json",
		"*.jsonc",
		"*.css",
		"*.scss",
		"*.html",
		"*.md",
		"*.vue",
		"*.svelte",
		"*.sh",
		"*.bash",
		"*.zsh",
		"*.c",
		"*.cpp",
		"*.h",
		"*.hpp",
	},
	callback = function(args)
		if vim.g.autoformat == false then
			return
		end
		-- avoid formatting non-file buffers (helps prevent weird write prompts)
		if vim.bo[args.buf].buftype ~= "" then
			return
		end
		if not vim.bo[args.buf].modifiable then
			return
		end
		if vim.api.nvim_buf_get_name(args.buf) == "" then
			return
		end

		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" and c:supports_method("textDocument/formatting", args.buf) then
				has_efm = true
				break
			end
		end
		if not has_efm then
			vim.notify_once("Format on save is enabled, but no EFM formatter is attached to this buffer", vim.log.levels.WARN)
			return
		end

		local ok, err = pcall(vim.lsp.buf.format, {
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(c)
				return c.name == "efm"
			end,
		})
		if not ok then
			vim.notify("Format on save failed: " .. tostring(err), vim.log.levels.ERROR)
		end
	end,
})

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then -- except in diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- reload files changed outside Neovim (branch switch, formatter, other editor)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = augroup,
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- auto-trim trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	callback = function()
		if vim.bo.buftype == "" then
			MiniTrailspace.trim()
		end
	end,
})

-- relative number toggle: absolute in insert, relative in normal
vim.api.nvim_create_autocmd("InsertEnter", {
	group = augroup,
	callback = function()
		vim.opt_local.relativenumber = false
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = augroup,
	callback = function()
		vim.opt_local.relativenumber = true
	end,
})

-- expose augroup for other modules that need it (lsp, terminal)
return augroup
