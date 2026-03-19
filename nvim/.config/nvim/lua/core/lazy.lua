--------------------------------------------------
-- Bootstrap lazy.nvim Package Manager
--------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- Load All Plugins
--------------------------------------------------
require("lazy").setup({
	{ import = "plugins" },
	require("themes"), -- ← single active theme only
}, {
	change_detection = { notify = false },
})
