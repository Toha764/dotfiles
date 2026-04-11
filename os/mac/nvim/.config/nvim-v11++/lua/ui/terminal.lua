--------------------------------------------------
-- ui/terminal.lua
-- Floating terminal — opens in the current file's directory
--------------------------------------------------

local M = {}

local state = {
	buf = nil,
	win = nil,
	is_open = false,
}

local function set_highlights()
	vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })
end

local function get_win_opts()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	return {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
	}
end

local function buf_has_content(buf)
	for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
		if line ~= "" then
			return true
		end
	end
	return false
end

function M.toggle()
	-- Capture dir BEFORE any window switch
	local file_dir = vim.fn.expand("%:p:h")

	-- Close if already open
	if state.is_open and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, false)
		state.is_open = false
		return
	end

	-- Create or reuse buffer
	if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[state.buf].bufhidden = "hide"
	end

	-- Open floating window
	set_highlights()
	state.win = vim.api.nvim_open_win(state.buf, true, get_win_opts())
	vim.wo[state.win].winblend = 0
	vim.wo[state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"

	-- Start shell only on first open
	if not buf_has_content(state.buf) then
		vim.fn.termopen(os.getenv("SHELL"), { cwd = file_dir })
	end

	state.is_open = true
	vim.cmd("startinsert")

	-- Auto-close when focus leaves the terminal buffer
	vim.api.nvim_create_autocmd("BufLeave", {
		buffer = state.buf,
		once = true,
		callback = function()
			if state.is_open and vim.api.nvim_win_is_valid(state.win) then
				vim.api.nvim_win_close(state.win, false)
				state.is_open = false
			end
		end,
	})
end

function M.close()
	if state.is_open and vim.api.nvim_win_is_valid(state.win) then
		vim.api.nvim_win_close(state.win, false)
		state.is_open = false
	end
end

function M.setup()
	vim.keymap.set("n", "<leader>t", M.toggle, {
		noremap = true,
		silent = true,
		desc = "Toggle floating terminal",
	})
	vim.keymap.set("t", "<Esc>", M.close, {
		noremap = true,
		silent = true,
		desc = "Close floating terminal",
	})
end

return M
