local function noremap(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
-- First time it is opened, open it at the repo root
noremap('n', '<C-t>', "!exists('g:NERDTree') ? ':NERDTreeVCS<CR>' : ':NERDTreeToggle<CR>'", {expr = true, silent = true})
noremap('n', '\\t', ":NERDTreeFind<CR>", {silent = true})
vim.g.NERDTreeQuitOnOpen = 1
vim.g.NERDTreeMinimalUI = 1
-- Exit Vim if NERDTree is the only window remaining in the only tab.
vim.cmd [[autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]]
-- Close the tab if NERDTree is the only window remaining in it.
vim.cmd [[autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif]]
