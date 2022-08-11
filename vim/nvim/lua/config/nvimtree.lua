require("nvim-tree").setup({
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
    }
})

