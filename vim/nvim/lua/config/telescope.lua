local actions = require 'telescope.actions'
local telescope = require 'telescope'
telescope.setup{
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key",
                ["<C-k>"] = actions.cycle_history_next,
                ["<C-j>"] = actions.cycle_history_prev,
            }
        },
        history = {
            path = '~/.local/share/nvim/databases/telescope_history.sqlite3',
            limit = 500,
        },
        preview = {
            filesize_limit = .9
        }
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown { },
        }
    }
}

telescope.load_extension 'ui-select'
telescope.load_extension 'attempt'

if vim.fn.has('unix') == 1 then
    telescope.load_extension 'fzf'
    telescope.load_extension 'smart_history'
end

