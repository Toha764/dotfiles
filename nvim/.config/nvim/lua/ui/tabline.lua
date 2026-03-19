--------------------------------------------------
-- ui/tabline.lua
-- Buffer-based tabline with leader+1–9 navigation
--------------------------------------------------

local M = {}

-- ── Rendering ────────────────────────────────────────────────────────────────

--- Returns only listed, real buffers (skips terminals, nofile scratch, etc.)
local function listed_bufs()
	return vim.tbl_filter(function(b)
		return vim.bo[b].buflisted
			and vim.api.nvim_buf_is_valid(b)
			and (vim.bo[b].buftype == "" or vim.bo[b].buftype == "terminal")
	end, vim.api.nvim_list_bufs())
end

local function buf_label(buf)
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return "[No Name]"
	end
	-- Show only the filename, not the full path
	return vim.fn.fnamemodify(name, ":t")
end

local function buf_modified(buf)
	return vim.bo[buf].modified and " ●" or ""
end

function M.render()
	local bufs = listed_bufs()
	local current = vim.api.nvim_get_current_buf()
	local line = ""

	for i, buf in ipairs(bufs) do
		local label = buf_label(buf)
		local modified = buf_modified(buf)
		local index = i <= 9 and (" " .. i .. " ") or "   "

		if buf == current then
			line = line .. "%#TabLineSel#" .. index .. label .. modified .. " %#TabLine#"
		else
			line = line .. "%#TabLine#" .. index .. label .. modified .. " "
		end
	end

	-- Fill remaining space
	line = line .. "%#TabLineFill#"
	return line
end

-- ── Buffer close ─────────────────────────────────────────────────────────────

local function close_current_buf()
	local current = vim.api.nvim_get_current_buf()
	local bufs = listed_bufs()

	if #bufs <= 1 then
		vim.cmd("quit")
		return
	end

	for i, buf in ipairs(bufs) do
		if buf == current then
			local target = bufs[i + 1] or bufs[i - 1]
			vim.api.nvim_set_current_buf(target)
			break
		end
	end

	vim.api.nvim_buf_delete(current, { force = false })
end

-- ── Jump to buffer by index ───────────────────────────────────────────────────

local function go_to_buf(n)
	local bufs = listed_bufs()
	if bufs[n] then
		vim.api.nvim_set_current_buf(bufs[n])
	end
end

-- ── Setup ─────────────────────────────────────────────────────────────────────

function M.setup()
	-- Activate the custom tabline
	vim.opt.showtabline = 2
	vim.opt.tabline = "%!v:lua.require('ui.tabline').render()"

	-- Close buffer / quit
	vim.keymap.set("n", "<leader>w", close_current_buf, { desc = "Close buffer" })

	-- New tab (actual vim tab, useful for split workspaces)
	vim.keymap.set("n", "<leader>nt", "<cmd>tabnew<CR>", { desc = "New tab" })

	-- Jump to buffer 1–9
	for i = 1, 9 do
		vim.keymap.set("n", "<leader>" .. i, function()
			go_to_buf(i)
		end, { desc = "Go to buffer " .. i })
	end
end

return M
