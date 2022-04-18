local map  = require('utils').map

-- First time it is opened, open it at the repo root
map('n', '<C-t>', "!exists('g:NERDTree') ? ':NERDTreeVCS<CR>' : ':NERDTreeToggle<CR>'", {expr=true})
map('n', '\\t', ":NERDTreeFind<CR>")
vim.g.NERDTreeQuitOnOpen = 1
vim.g.NERDTreeMinimalUI = 1
-- Exit Vim if NERDTree is the only window remaining in the only tab.
vim.cmd [[autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]]
-- Close the tab if NERDTree is the only window remaining in it.
vim.cmd [[autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]]
