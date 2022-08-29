local unix = vim.fn.has 'unix' == 1

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

require("nvim-tree").setup({
    hijack_netrw = false,
    view = {
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    actions = {
        use_system_clipboard = true,
        open_file = {
            quit_on_open = true
        }
    },
    renderer = {
        icons = {
            show = (not unix) and hide_icons,
            glyphs = {
                folder = (not unix) and non_icon_folders
            }
        }
    }
})

