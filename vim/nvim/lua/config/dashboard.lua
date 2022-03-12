local g = vim.g

g.dashboard_default_executive = "telescope"

g.dashboard_custom_header = {
    'Welcome to neovim',
}

g.dashboard_custom_footer = { '' }

g.dashboard_custom_section = {
    last_session = {
        description = { 'Open last session         SPC s l' },
        command = 'SessionLoad'
    },
    git_files = {
        description = { 'Find file                 C-p    ' },
        command = 'Telescope git_files'
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
vim.api.nvim_set_keymap('n', '<leader>sl', '<cmd>SessionLoad<CR>', options)
vim.api.nvim_set_keymap('n', '<leader>cn', '<cmd>DashboardNewFile<CR>', options)
