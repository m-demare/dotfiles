return {
    { "tpope/vim-commentary" },
    { "tpope/vim-surround" },
    { "tpope/vim-repeat" },
    { "chentoast/marks.nvim", config = true },
    { "tpope/vim-sleuth" },
    {
        "romainl/vim-qf",
        lazy = false,
        keys = {
            { "[q", "<Plug>(qf_qf_previous)" },
            { "]q", "<Plug>(qf_qf_next)" },
            { "<F1>", "<Plug>(qf_qf_toggle_stay)" },
        },
    },
    {
        "m-demare/attempt.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        dev = true,
        opts = {
            autosave = true,
            ext_options = { "lua", "js", "py", "cpp", "c", "http", "" },
        },
        -- stylua: ignore
        keys = {
            { "<leader>an", function() require("attempt").new_select() end, },
            { "<leader>ai", function() require("attempt").new_input_ext() end, },
            { "<leader>ar", function() require("attempt").run() end, },
            { "<leader>ad", function() require("attempt").delete_buf() end, },
            { "<leader>ac", function() require("attempt").rename_buf() end, },
        },
    },
    {
        "ggandor/leap.nvim",
        config = function ()
            vim.keymap.set({"n"}, "s", "<Plug>(leap-forward)")
            vim.keymap.set({"x"}, "x", "<Plug>(leap-forward)")
            vim.keymap.set({"o"}, "gs", "<Plug>(leap-forward)")

            vim.keymap.set({"n"}, "S", "<Plug>(leap-backward)")
            vim.keymap.set({"x"}, "X", "<Plug>(leap-backward)")
            vim.keymap.set({"o"}, "gS", "<Plug>(leap-backward)")
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {
                disable_filetype = { "TelescopePrompt", "vim" },
                enable_check_bracket_line = true,
            }
        end,
    },
    {
        "folke/persistence.nvim",
        event = "BufReadPre", -- start saving session when an actual file was opened
        config = true,
        keys = {
            {
                "<leader>sl",
                function()
                    require("persistence").load()
                end,
            },
        },
    },
    {
        "mbbill/undotree",
        config = function()
            vim.g.undotree_SetFocusWhenToggle = 1
        end,
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<CR>" },
        },
    },
    {
        "rest-nvim/rest.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        commit = "1ddcc92a6af701f83c13a22212449e451432d2dc",
        keys = {
            { "<leader>sr", "<Plug>RestNvim" },
        },
    },
}
