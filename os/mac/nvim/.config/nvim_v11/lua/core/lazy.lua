--------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- prefer vim.uv (new API), fallback to vim.loop
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"

	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})

	if vim.v.shell_error ~= 0 then
		vim.api.nvim_err_writeln("Failed to clone lazy.nvim:\n" .. out)
		return
	end
end

vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- Plugins
--------------------------------------------------

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "themes" },
	},
	change_detection = {
		notify = false,
	},
	install = {
		colorscheme = { "gruvbox, " },
	},
})
