local ok, yazi = pcall(require, "yazi")
if not ok then return end

yazi.setup({
  open_for_directories = true,
})
