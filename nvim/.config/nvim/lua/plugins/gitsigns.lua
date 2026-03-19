--------------------------------------------------
-- Git Integration (Gitsigns) Configuration *
--------------------------------------------------

return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()
    end,
}
