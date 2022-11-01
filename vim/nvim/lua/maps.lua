local map = require('utils').map

map('n', '<leader>ll', '<cmd>luafile %<CR>')

-- Git
map('n', '<leader>gg', '<cmd>G<CR>')
map('n', '<leader>gh', '<cmd>diffget //2<CR>')
map('n', '<leader>gl', '<cmd>diffget //3<CR>')
map('n', '<leader>gB', '<cmd>GBrowse<CR>')

-- vim-qf
map('n', '[q', '<Plug>(qf_qf_previous)')
map('n', ']q', '<Plug>(qf_qf_next)')
map('n', '<F1>', '<Plug>(qf_qf_toggle_stay)')


