local db = require 'dashboard'
local telescope = require 'config.telescope_setup'
local utils = require 'utils'
local map = utils.map
local attempt = utils.bind(require, 'attempt')

db.custom_header = { '', '', 'Welcome to neovim', '', '' }
db.custom_footer = { '' }
db.custom_center = {{
        desc = 'Open last session         SPC s l' ,
        action = 'SessionLoad'
    }, {
        desc = 'Find file                 C-p    ',
        action = telescope.project_files
    }, {
        desc = 'Find word                 SPC /  ',
        action = telescope.picker 'live_grep'
    }, {
        desc = 'Temp file                 SPC a n',
        action = utils.call_bind(attempt, 'new_select')
    },
}

db.session_directory = '~/.local/share/dashboard'

map('n', '<leader>sl', '<cmd>SessionLoad<CR>')

