local utils = require "utils"
local unix = utils.unix
local ts_utils = require "utils.telescope"

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "m-demare/attempt.nvim",
            {
                "nvim-telescope/telescope-ui-select.nvim",
                init = function()
                    ---@diagnostic disable-next-line: duplicate-set-field
                    vim.ui.select = function(...)
                        vim.cmd [[Lazy load telescope.nvim]]
                        return vim.ui.select(...)
                    end
                end,
            },
            {
                "nvim-telescope/telescope-smart-history.nvim",
                dependencies = "tami5/sqlite.lua",
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = unix and "make clean && make" or nil,
            },
        },
        cmd = "Telescope",
        config = function(_, opts)
            local telescope = require "telescope"
            telescope.setup(opts)
            telescope.load_extension "ui-select"
            telescope.load_extension "attempt"

            if unix then
                telescope.load_extension "fzf"
                telescope.load_extension "smart_history"
            end
        end,
        opts = function()
            local actions = require "telescope.actions"
            return {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-h>"] = "which_key",
                            ["<C-k>"] = actions.cycle_history_next,
                            ["<C-j>"] = actions.cycle_history_prev,
                            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                        },
                    },
                    history = {
                        path = "~/.local/share/nvim/databases/telescope_history.sqlite3",
                        limit = 500,
                    },
                    preview = {
                        filesize_limit = 0.9,
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {},
                    },
                },
            }
        end,

        -- stylua: ignore
        keys = {
            { "<C-p>", ts_utils.project_files },
            { "<leader>ff", ts_utils.picker("find_files", { file_ignore_patterns = { "^.git" }, no_ignore=true, no_ignore_parent=true, hidden=true }) },
            { "<leader><C-p>", ts_utils.picker "buffers" },
            { "<leader>/", ts_utils.picker("live_grep", { file_ignore_patterns = { "^.git" }, additional_args={ "--hidden" } }) },
            { "<leader>?", ts_utils.grep_string, mode = { "n", "v" } },
            { "<leader>gb", ts_utils.picker "git_branches" },
            { "<leader>al", ts_utils.extension_picker("attempt", "attempt") },
        },
    },
}
