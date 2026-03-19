--------------------------------------------------
-- File Management (Yazi) Configuration *
--------------------------------------------------

return {
    "mikavilpas/yazi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>e", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    },
    config = function()
        require("yazi").setup()
    end,
}
