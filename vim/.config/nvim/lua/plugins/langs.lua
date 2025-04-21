local utils = require "utils"

return {
    {
        "Canop/nvim-bacon",
        ft = "rust",
        opts = {
            quickfix = {
                enabled = true,
                event_trigger = true,
            },
        },
        keys = {
            { "<leader>bl", "<cmd>BaconLoad<CR><cmd>copen<CR>" },
        },
    },
    {
        "lervag/vimtex",
        ft = { "tex" },
        config = function()
            vim.g.vimtex_view_method = utils.mac and "skim" or "zathura"
        end,
    },
    {
        "vxpm/ferris.nvim",
        ft = "rust",
        config = true,
    },
}
