set number
set ruler
set scrolloff=3
set foldcolumn=0
set nowrap
set listchars=tab:▸\ 
set list
filetype plugin indent on
set backspace=indent,eol,start
set updatetime=300
set mouse=a
set relativenumber
set signcolumn=yes
set cursorline
highlight clear CursorLine
set splitright
set foldmethod=marker
set pumheight=8

set wildmenu
set showcmd

set autoread
au FocusGained,BufEnter * if mode() != 'c' | checktime | endif
set hidden

set belloff=all

nnoremap <SPACE> <Nop>
let mapleader = " "


" Indentation
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set smarttab


" search
set incsearch
set hls
nmap <silent> <leader>q :nohls<cr>
set ignorecase
set smartcase
set magic


" <leader>d to actually delete
" "0p pastes from yank register btw
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap x "_x

" <leader>y and <leader>p use clipboard
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

nnoremap <leader>K :help <C-r><C-w><CR>

" sudo save with :W
" command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

command! Wq wq
command! Q q
command! Qa qa
command! Wqa wqa

" Movement
set whichwrap+=<,>,h,l
nnoremap zh z6h
nnoremap zl z6l
nnoremap <leader>H ^
nnoremap <leader>L $


" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") && &filetype != 'gitcommit' | exe "normal! g'\"" | endif


" Disable arrows
noremap <Up>    <Nop>
noremap <Down>  <Nop>
noremap <Left>  <Nop>
noremap <Right> <Nop>


" Disable backups
set nobackup
set nowb
set noswapfile


" Visual mode pressing *
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


" Movement between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Window resizing
nnoremap <M-j> :resize -2<CR>
nnoremap <M-k> :resize +2<CR>
nnoremap <M-h> :vertical resize -2<CR>
nnoremap <M-l> :vertical resize +2<CR>


" Tabs management
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext
map <leader><tab> :tabnext<cr>
map <leader>tp :tabprevious<cr>

" Toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/


" Delete trailing white space on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

autocmd BufWritePre *.txt,*.json,*.xml,*.js,*.jsx,*.ts,*.tsx,*.py,*.lua,*.sh,*.java,*.c,*.h,*.cpp :call CleanExtraSpaces()

" Sppelling
set spelllang=es,en

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" Spelling shortcuts
" [s and ]s to move between errors
" <leader>sa add word to dict (compile manually added words with :mkspell)
" <leader>s? see sugestions
map <leader>sa zg
map <leader>s? z=


" Others

" Indenting selection
vnoremap < <gv
vnoremap > >gv

" Small syntax specific stuff

" Wrap text on some files
function! DoWrap()
    let ext=expand('%:e')
    if ext =~ 'md\|tex'
        set textwidth=85
    elseif ext =~ 'txt' || ext == ''
        set linebreak
        set wrap
    else
        set nowrap
    endif
endfunction
au BufRead,BufEnter,BufNewFile * call DoWrap()
au BufNew,BufRead *.asm set ft=ia64

" Helper functions

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Maps

nnoremap cn *``cgn

nnoremap gV `[v`]

snoremap <BS> <BS>i

nnoremap <leader>jq <CMD>%!jq<CR>

cnoremap %% <C-R>=expand('%')<cr>

cnoremap %/ <C-R>=expand('%:h').'/'<cr>

