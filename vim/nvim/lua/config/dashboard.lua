local g = vim.g
local telescope = require 'config.telescope_setup'
local map = require('utils').map

g.dashboard_default_executive = "telescope"

g.dashboard_custom_header = { 'Welcome to neovim' }

g.dashboard_custom_footer = { '' }

g.dashboard_custom_section = {
    last_session = {
        description = { 'Open last session         SPC s l' },
        command = 'SessionLoad'
    },
    git_files = {
        description = { 'Find file                 C-p    ' },
        command = telescope.project_files
    },
    new_file = {
        description = { 'Temp file                 SPC a n' },
        command = 'DashboardNewFile'
    },
    find_word = {
        description = { 'Find word                 SPC /  ' },
        command = telescope.picker 'live_grep'
    }
}

map('n', '<leader>sl', '<cmd>SessionLoad<CR>')

