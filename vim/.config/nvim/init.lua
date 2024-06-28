vim.loader.enable()

if vim.fn.has "unix" == 1 then
    vim.g.python3_host_prog = "/usr/bin/python3"
else
    vim.g.python3_host_prog = "C:\\Windows\\py"
    vim.g.node_host_prog = "C:\\Program Files\\nodejs\\"
end

vim.g.editorconfig = true
vim.g.mapleader = " "
vim.o.mousemodel = "extend"
if vim.fn.has "termguicolors" == 1 then vim.o.termguicolors = true end

vim.cmd "source ~/.config/vim/globals.vim"

-- make all keymaps silent by default
local keymap_set = vim.keymap.set
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    return keymap_set(mode, lhs, rhs, opts)
end

require "config.lazy"

require "config.autocmds"
vim.defer_fn(function()
    require "config.maps"
end, 20)
