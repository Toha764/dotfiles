--------------------------------------------------
-- Bootstrap lazy.nvim — nvim 0.11
--------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
	local out = vim.fn.system({
		"git", "clone", "--filter=blob:none", "--branch=stable",
		"https://github.com/folke/lazy.nvim.git", lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Failed to clone lazy.nvim:\n" .. out)
		return
	end
end

vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- Plugin spec
-- NOTE: lualine is intentionally excluded — custom statusline in ui/statusline.lua
--       comment.lua excluded — mini.comment handles it
--------------------------------------------------

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "themes" },
	},
	change_detection = { notify = false },
	install = { colorscheme = { "gruvbox", "habamax" } },
})
