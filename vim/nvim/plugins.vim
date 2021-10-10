" Plugins

" Install vim-plug if not already present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    echo "Installing vim-plug"
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" General
Plug 'jiangmiao/auto-pairs'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'preservim/nerdtree',          { 'on': ['NERDTreeToggle', 'NERDTreeVCS', 'NERDTreeFind']   }
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-lua/plenary.nvim'

" Theme
Plug 'tomasr/molokai'

" Git
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

" asm
Plug 'shirk/vim-gas',               { 'for': ['asm', 's']       }

" JS
Plug 'pangloss/vim-javascript',     { 'for': ['js', 'jsx']      }
Plug 'leafgarland/typescript-vim',  { 'for': ['ts', 'tsx']      }
Plug 'MaxMEllon/vim-jsx-pretty',    { 'for': ['jsx', 'tsx']     }

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'RRethy/vim-illuminate'

call plug#end()

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


" Settings

" Git signs
lua require('gitsigns').setup()

" Colors
colorscheme molokai

" Lightline
set noshowmode
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" NERDTree
" First time it is opened, open it at the repo root
nnoremap <expr> <C-t> !exists("g:NERDTree") ? ':NERDTreeVCS<CR>' : ':NERDTreeToggle<CR>'
nnoremap <silent> <leader>t :NERDTreeFind<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeMinimalUI = 1
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" set vim-gas syntax for asm
au BufRead,BufNewFile *.asm set filetype=gas
au BufRead,BufNewFile *.asm syn region Comment start=/;/ end=/$/

" Highlight JSDocs
let g:javascript_plugin_jsdoc = 1

" Disable autopairs for vim files (gets annoying with the quotes)
au Filetype vim let b:AutoPairs = {}

" ctrlP ignore untracked files
if has('unix')
    let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', 'cd %s && (git status --short| grep "^?" | cut -d\  -f2- && git ls-files)'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
        \ 'fallback': 'find %s -type f'
        \ }
else
    let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', 'git ls-files'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
        \ 'fallback': 'dir %s /-n /b /s /a-d'
        \ }
endif


" Colorizer
if has("termguicolors")
    set termguicolors
    lua require'colorizer'.setup()
endif

