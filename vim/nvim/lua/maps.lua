local utils = require('utils')
local map = utils.map
local nmap = utils.bind(map, 'n')
local M = {}

nmap('<leader>ll', '<cmd>luafile %<CR>')

-- Git
nmap('<leader>gg', '<cmd>G<CR>')
nmap('<leader>gh', '<cmd>diffget //2<CR>')
nmap('<leader>gl', '<cmd>diffget //3<CR>')
nmap('<leader>gB', '<cmd>GBrowse<CR>')

-- vim-qf
nmap('[q', '<Plug>(qf_qf_previous)')
nmap(']q', '<Plug>(qf_qf_next)')
nmap('<F1>', '<Plug>(qf_qf_toggle_stay)')

M.map_open_mdn = function (bufnr)
    local base_url = 'https://developer.mozilla.org/en-US/search?q='
    map({'n', 'v'}, '<leader>K', function ()
        local word
        if vim.fn.mode() == 'v' then
            local saved_reg = vim.fn.getreg 'v'
            vim.cmd [[noautocmd sil norm "vy]]
            local sel = vim.fn.getreg 'v'
            vim.fn.setreg('v', saved_reg)
            word = sel
        else
            word = vim.fn.expand '<cword>'
        end
        vim.cmd('noautocmd sil !xdg-open "' .. base_url .. word .. '"')
    end, {buffer=bufnr})
end

return M

