vim.o.showmode = false

local separators
local unix = vim.fn.has('unix') == 1
if not unix then
    separators = ''
end

local no_icons = {
    File          = '',
    Module        = '',
    Namespace     = '',
    Package       = '',
    Class         = '',
    Method        = '',
    Property      = '',
    Field         = '',
    Constructor   = '',
    Enum          = '',
    Interface     = '',
    Function      = '',
    Variable      = '',
    Constant      = '',
    String        = '',
    Number        = '',
    Boolean       = '',
    Array         = '',
    Object        = '',
    Key           = '',
    Null          = '',
    EnumMember    = '',
    Struct        = '',
    Event         = '',
    Operator      = '',
    TypeParameter = '',
}

local navic = require 'nvim-navic'
navic.setup{
    icons = unix and {} or no_icons,
    depth_limit = 2,
}

require('lualine').setup {
    options = {
        icons_enabled = unix,
        theme = 'sonokai',
        section_separators = separators,
        component_separators = separators,
        globalstatus = true
    },
    sections = {
        lualine_c = {
            'filename',
            { function() return navic.get_location() end , cond = navic.is_available }
        }
    }
}

