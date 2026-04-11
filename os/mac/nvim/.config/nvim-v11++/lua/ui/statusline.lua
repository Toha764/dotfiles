-- ============================================================================
-- Custom Statusline — ported from nvim-lite
-- No lualine dependency. Uses Nerd Font icons.
-- ============================================================================

-- Git branch with caching (refresh every 5s)
local cached_branch = ""
local last_check    = 0
local function git_branch()
	local uv  = vim.uv or vim.loop
	local now = uv.now()
	if now - last_check > 5000 then
		cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
		last_check    = now
	end
	if cached_branch ~= "" then
		return " \u{e725} " .. cached_branch .. " " -- nf-dev-git_branch
	end
	return ""
end

-- Filetype icon (Nerd Font)
local function file_type()
	local ft    = vim.bo.filetype
	local icons = {
		lua            = "\u{e620} ", -- nf-dev-lua
		python         = "\u{e73c} ", -- nf-dev-python
		javascript     = "\u{e74e} ", -- nf-dev-javascript
		typescript     = "\u{e628} ", -- nf-dev-typescript
		javascriptreact= "\u{e7ba} ",
		typescriptreact= "\u{e7ba} ",
		html           = "\u{e736} ", -- nf-dev-html5
		css            = "\u{e749} ", -- nf-dev-css3
		scss           = "\u{e749} ",
		json           = "\u{e60b} ", -- nf-dev-json
		markdown       = "\u{e73e} ", -- nf-dev-markdown
		vim            = "\u{e62b} ", -- nf-dev-vim
		sh             = "\u{f489} ", -- nf-oct-terminal
		bash           = "\u{f489} ",
		zsh            = "\u{f489} ",
		rust           = "\u{e7a8} ", -- nf-dev-rust
		go             = "\u{e724} ", -- nf-dev-go
		c              = "\u{e61e} ", -- nf-dev-c
		cpp            = "\u{e61d} ", -- nf-dev-cplusplus
		java           = "\u{e738} ", -- nf-dev-java
		php            = "\u{e73d} ", -- nf-dev-php
		ruby           = "\u{e739} ", -- nf-dev-ruby
		swift          = "\u{e755} ", -- nf-dev-swift
		kotlin         = "\u{e634} ",
		dart           = "\u{e798} ",
		elixir         = "\u{e62d} ",
		haskell        = "\u{e777} ",
		sql            = "\u{e706} ",
		yaml           = "\u{f481} ",
		toml           = "\u{e615} ",
		xml            = "\u{f05c} ",
		dockerfile     = "\u{f308} ", -- nf-linux-docker
		gitcommit      = "\u{f418} ", -- nf-oct-git_commit
		gitconfig      = "\u{f1d3} ", -- nf-fa-git
		vue            = "\u{fd42} ", -- nf-md-vuejs
		svelte         = "\u{e697} ",
		astro          = "\u{e628} ",
	}
	if ft == "" then return " \u{f15b} " end
	return (icons[ft] or " \u{f15b} ") .. ft
end

-- File size
local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then return "" end
	local s
	if     size < 1024           then s = size .. "B"
	elseif size < 1024 * 1024    then s = string.format("%.1fK", size / 1024)
	else                              s = string.format("%.1fM", size / (1024*1024))
	end
	return " \u{f016} " .. s .. " " -- nf-fa-file_o
end

-- Mode indicator
local function mode_icon()
	local mode  = vim.fn.mode()
	local modes = {
		n          = " \u{f121}  NORMAL",   -- nf-fa-code
		i          = " \u{f11c}  INSERT",   -- nf-fa-keyboard_o
		v          = " \u{f0168} VISUAL",   -- nf-md-select_all
		V          = " \u{f0168} V-LINE",
		["\22"]    = " \u{f0168} V-BLOCK",
		c          = " \u{f120} COMMAND",   -- nf-fa-terminal
		s          = " \u{f0c5} SELECT",
		S          = " \u{f0c5} S-LINE",
		["\19"]    = " \u{f0c5} S-BLOCK",
		R          = " \u{f044} REPLACE",   -- nf-fa-pencil
		r          = " \u{f044} REPLACE",
		["!"]      = " \u{f489} SHELL",
		t          = " \u{f120} TERMINAL",
	}
	return modes[mode] or (" \u{f059} " .. mode)
end

-- Expose as globals so %{v:lua.fn()} works in statusline strings
_G.mode_icon  = mode_icon
_G.git_branch = git_branch
_G.file_type  = file_type
_G.file_size  = file_size

vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

-- Focused window: full info
-- Unfocused window: minimal
local function setup()
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		callback = function()
			vim.opt_local.statusline = table.concat({
				"  ",
				"%#StatusLineBold#",
				"%{v:lua.mode_icon()}",
				"%#StatusLine#",
				" \u{e0b1} %f %h%m%r",  -- nf-pl-left_hard_divider
				"%{v:lua.git_branch()}",
				"\u{e0b1} ",
				"%{v:lua.file_type()}",
				"\u{e0b1} ",
				"%{v:lua.file_size()}",
				"%=",                    -- right-align
				" \u{f017} %l:%c  %P ", -- clock icon, line:col, percent
			})
		end,
	})

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.opt_local.statusline =
				"  %f %h%m%r \u{e0b1} %{v:lua.file_type()} %=  %l:%c   %P "
		end,
	})
end

setup()
