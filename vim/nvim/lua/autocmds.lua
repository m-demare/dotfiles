local utils = require('utils')
local map = utils.map
local nmap = utils.bind(map, 'n')
local map_open_mdn = require('maps').map_open_mdn

local group = vim.api.nvim_create_augroup('my_aucmds', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
    group    = group,
    pattern  = '*',
    callback = function() vim.highlight.on_yank { on_visual = true, timeout = 250 } end
})

vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'netrw',
    callback = function()
        -- Go back in history
        nmap('H', 'u', {buffer=true, remap=true})
        -- Go up a directory
        nmap('h', '-^', {buffer=true, remap=true})
        -- Go down a directory / open file
        nmap('l', '<CR>', {buffer=true, remap=true})
    end
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = group,
    pattern = { "*.txt", "*.md", "*.tex" },
    command = "setlocal spell"
})

local js_fts = {'javascript', 'typescript', 'typescriptreact', 'javascriptreact'}
vim.api.nvim_create_autocmd('FileType', {
    group=group,
    callback = function (ev)
        if utils.unix and vim.tbl_contains(js_fts, ev.match) then
            map_open_mdn(ev.buf)
        end
    end
})

