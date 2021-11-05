local g = vim.g

g.dashboard_default_executive = "telescope"

g.dashboard_custom_header = {
    '                  ▟▙           ',
    '██▃▅▇█▆▖ ██▄  ▄██ ▝▘ ▗▟█▆▄▄▆█▙▖',
    '██▛▔ ▝██ ▝██  ██▘ ██ ██▛▜██▛▜██',
    '██    ██  ▜█▙▟█▛  ██ ██  ██  ██',
    '██    ██  ▝████▘  ██ ██  ██  ██',
    '▀▀    ▀▀    ▀▀    ▀▀ ▀▀  ▀▀  ▀▀',
}

g.dashboard_custom_footer = { '' }

g.dashboard_custom_section = {
    last_session = {
        description = { 'Open last session         SPC s l' },
        command = 'SessionLoad'
    },
    find_file = {
        description = { 'Find file                 SPC C-p' },
        command = 'DashboardFindFile'
    },
    new_file = {
        description = { 'New file                  SPC c n' },
        command = 'DashboardNewFile'
    },
    find_word = {
        description = { 'Find word                 SPC /  ' },
        command = 'DashboardFindWord'
    }
}

local options = {noremap = true, silent = true}
vim.api.nvim_set_keymap('n', '<space>sl', '<cmd>SessionLoad<CR>', options)
vim.api.nvim_set_keymap('n', '<space>cn', '<cmd>DashboardNewFile<CR>', options)
