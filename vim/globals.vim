set number
set ruler
set scrolloff=5
set foldcolumn=0
set nowrap
set listchars=tab:▸\ 
set list
filetype plugin indent on
set backspace=indent,eol,start
set updatetime=300
set mouse=a

set wildmenu
set showcmd

set autoread
au FocusGained,BufEnter * checktime
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
nmap <silent> <esc><esc> :nohls<cr>
set ignorecase
set smartcase
set magic


" ,d to actually delete
" "0p pastes from yank register btw
nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap x "_x

" ,y and ,p use clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p


" sudo save with :W
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!


" Movement
set whichwrap+=<,>,h,l
map 0 ^


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


" Movement between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" Tabs management
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 
map <leader>t<leader> :tabnext
map <leader>tp :tabprevious

" Let ,tl toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/


" Delete trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.json,*.xml,*.js,*.jsx,*.ts,*.tsx,*.py,*.lua,*.sh,*.java :call CleanExtraSpaces()
endif


" Sppelling
set spelllang=en,es

" ,ss toggles spell checking
map <leader>ss :setlocal spell!<cr>

" Spelling shortcuts
" [s and ]s to move between errors
" ,sa add word to dict
" ,s? see sugestions
map <leader>sa zg
map <leader>s? z=


" Others

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
    set signcolumn=number
else
    set signcolumn=yes
endif


" Small syntax specific stuff

" Wrap text on some files
function! DoWrap()
    let ext=expand('%:e')
    if ext =~ 'md\|tex'
        set textwidth=120
    elseif ext =~ 'txt' || ext == ''
        set linebreak
        set wrap
    else
        set nowrap
    endif
endfunction
au BufRead,BufEnter,BufNewFile * call DoWrap()


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

