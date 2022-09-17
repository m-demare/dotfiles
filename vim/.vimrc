set nocompatible

source ~/.config/vim/globals.vim

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'tpope/vim-fugitive'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'sainnhe/sonokai'

call plug#end()

let g:ctrlp_show_hidden = 1

colorscheme sonokai

set guicursor=n-c-v:block-nCursor,i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150

