pcall(require, 'impatient')

if vim.fn.has("unix") == 1 then
    vim.g.python3_host_prog="/usr/bin/python3.11"
else
    vim.g.python3_host_prog="C:\\Windows\\py"
    vim.g.node_host_prog = 'C:\\Program Files\\nodejs\\'
end

vim.g.editorconfig = true
vim.g.mapleader = ' '
if vim.fn.has('termguicolors') == 1 then
    vim.o.termguicolors = true
end

require('plugins')

vim.cmd('source ~/.config/vim/globals.vim')

require 'autocmds'
vim.defer_fn(function ()
    require 'maps'
end, 2)

vim.o.mousemodel='extend'

