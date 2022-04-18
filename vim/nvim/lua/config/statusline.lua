vim.o.showmode = false
vim.g.NERDTreeStatusline = -1

local separators
local unix = vim.fn.has('unix') == 1
if not unix then
    separators = ''
end

local gps = require 'nvim-gps'
gps.setup{
    disable_icons = not unix,
    depth = 2,
}

require('lualine').setup {
    options = {
        icons_enabled = unix,
        theme = 'sonokai',
        section_separators = separators,
        component_separators = separators,
        globalstatus = true
    },
    extensions = {'nerdtree'},
    sections = {
        lualine_c = {
            'filename',
            { gps.get_location, cond = gps.is_available }
        }
    }
}

