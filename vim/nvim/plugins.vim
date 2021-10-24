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

" Theme
Plug 'tomasr/molokai'

" Git
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" asm
Plug 'shirk/vim-gas',               { 'for': ['asm', 's']       }

" JS
Plug 'pangloss/vim-javascript',     { 'for': ['js', 'jsx']      }
Plug 'leafgarland/typescript-vim',  { 'for': ['ts', 'tsx']      }
Plug 'MaxMEllon/vim-jsx-pretty',    { 'for': ['jsx', 'tsx']     }

let using_coc=0
if has("unix")
    if isdirectory($HOME . "/.nvm/versions/node/" . $vim_node_version . "/bin/")
        let g:coc_node_path = $HOME . "/.nvm/versions/node/" . $vim_node_version . "/bin/node"
        let g:coc_global_extensions = [ 'coc-tsserver', 'coc-pyright', 'coc-snippets' ]
        " TODO consider loading it manually for faster startup
        " (https://github.com/junegunn/vim-plug/wiki/tips#loading-plugins-manually)
        Plug 'neoclide/coc.nvim',   { 'branch': 'release'       }
        Plug 'honza/vim-snippets'
        let using_coc=1
    endif
endif


call plug#end()

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


" Settings

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

if using_coc
    " use <tab> for trigger completion and navigate to the next complete item
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction
    inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    " Here, leader = \
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)
endif
