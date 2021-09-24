set number
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

" Disable arrows
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>

nnoremap <esc><esc> :silent! nohls<cr>
set ic

set scrolloff=3

" \d to actually delete
" "0p pastes from yank register btw
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap x "_x
xnoremap x "_x

" \y and \p use clipboard
nnoremap <leader>y "+y
nnoremap <leader>p "+p

