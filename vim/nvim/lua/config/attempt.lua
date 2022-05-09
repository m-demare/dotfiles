local map = require 'utils'.map
local attempt = require('attempt')
local telescope = require 'config.telescope_setup'

attempt.setup {
    autosave = true
}

map('n', '<leader>an', attempt.new_select)
map('n', '<leader>al', telescope.extension_picker('attempt', 'attempts'))
map('n', '<leader>ar', attempt.run)

