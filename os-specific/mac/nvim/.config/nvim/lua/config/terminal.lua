-- ============================================================================
-- FLOATING TERMINAL
-- ============================================================================
local augroup = require("config.autocmds")

vim.api.nvim_create_autocmd("TermClose", {
	group = augroup,
	callback = function(args)
		if vim.v.event.status == 0 and not vim.b[args.buf].keep_on_exit then
			vim.api.nvim_buf_delete(args.buf, { force = true })
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = augroup,
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end,
})

local terminal_state = { buf = nil, win = nil, is_open = false }

local function open_float(buf)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[win].winblend = 0
	vim.wo[win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
	vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })
	return win
end

local function RunInFloatingTerminal(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.b[buf].keep_on_exit = true
	local win = open_float(buf)
	local job = vim.fn.jobstart(cmd, { term = true })
	if job <= 0 then
		vim.api.nvim_win_close(win, false)
		vim.api.nvim_buf_delete(buf, { force = true })
		vim.notify("Could not start the runner terminal (jobstart " .. job .. ")", vim.log.levels.ERROR)
		return
	end
	vim.cmd("startinsert")
end

local function FloatingTerminal()
	if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
		terminal_state.is_open = false
		vim.api.nvim_win_close(terminal_state.win, false)
		return
	end

	if not terminal_state.buf or not vim.api.nvim_buf_is_valid(terminal_state.buf) then
		terminal_state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[terminal_state.buf].bufhidden = "hide"
	end

	terminal_state.win = open_float(terminal_state.buf)

	if vim.bo[terminal_state.buf].buftype ~= "terminal" then
		vim.fn.termopen(os.getenv("SHELL"))
	end

	terminal_state.is_open = true
	vim.cmd("startinsert")

	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = terminal_state.buf,
		callback = function()
			if terminal_state.is_open and terminal_state.win and vim.api.nvim_win_is_valid(terminal_state.win) then
				vim.api.nvim_win_close(terminal_state.win, false)
				terminal_state.is_open = false
			end
		end,
		once = true,
	})
end

vim.keymap.set("n", "<leader>tt", FloatingTerminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
vim.keymap.set("t", "<Esc>", function()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	if vim.api.nvim_win_get_config(win).relative ~= "" and vim.bo[buf].buftype == "terminal" then
		local preserve = terminal_state.buf == buf
		if terminal_state.win == win then
			terminal_state.is_open = false
		end
		vim.api.nvim_win_close(win, false)
		if not preserve and vim.api.nvim_buf_is_valid(buf) then
			pcall(vim.api.nvim_buf_delete, buf, { force = true })
		end
	end
end, { noremap = true, silent = true, desc = "Close floating terminal" })

return {
	toggle = FloatingTerminal,
	run = RunInFloatingTerminal,
}
