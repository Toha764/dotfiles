--------------------------------------------------
-- Git Integration (Gitsigns) Configuration *
--------------------------------------------------

return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("os.mac.nvim.config.nvim.lua.config.gitsigns").setup()
    end,
}
