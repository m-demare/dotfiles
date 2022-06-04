local map = require('utils').map

map('n', '<leader>ll', '<cmd>luafile %<CR>')

-- Git
map('n', '<leader>gg', '<cmd>G<CR>')
map('n', '<leader>gh', ':diffget //2<CR>')
map('n', '<leader>gl', ':diffget //3<CR>')
