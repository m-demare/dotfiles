local utils = require('utils')
local unix = utils.unix
local map = utils.map

local hide_icons = {
    file = false,
    folder = false,
    folder_arrow = true,
    git = false
}

local non_icon_folders = {
    arrow_closed = ">",
    arrow_open = "v",
    default = ">",
    open = "v",
    empty = ">",
    empty_open = "v",
    symlink = ">",
    symlink_open = "v",
}

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, nowait = true }
  end

  -- :h nvim-tree-mappings-default
  api.config.mappings.default_on_attach(bufnr)

  map('n', 'u', api.tree.change_root_to_parent, opts('Up'))
end

require("nvim-tree").setup({
    hijack_netrw = false,
    on_attach=on_attach,
    actions = {
        use_system_clipboard = true,
        open_file = {
            quit_on_open = true
        }
    },
    renderer = {
        icons = {
            show = unix and {} or hide_icons,
            glyphs = {
                folder = unix and {} or non_icon_folders
            }
        }
    }
})

