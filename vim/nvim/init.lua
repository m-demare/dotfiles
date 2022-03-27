if vim.fn.has("unix") == 1 then
    vim.g.python3_host_prog="/usr/bin/python3.10"
    vim.g.node_host_prog = vim.fn.getenv 'HOME' ..
        "/.nvm/versions/node/" ..
        vim.fn.getenv 'vim_node_version' ..
        "/bin/node"
else
    vim.g.python3_host_prog="C:\\Windows\\py"
    vim.g.node_host_prog = 'C:\\Program Files\\nodejs\\'
end

vim.g.mapleader = ' '
if vim.fn.has('termguicolors') == 1 then
    vim.o.termguicolors = true
end

require('plugins')

vim.cmd('source ~/.config/vim/globals.vim')

require('lsp')

vim.cmd[[
    augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank {on_visual=false, higroup="IncSearch", timeout=250}
    augroup END
]]
