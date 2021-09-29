" Plugins

" Install vim-plug if not already present
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    echo "Installing vim-plug"
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'shirk/vim-gas',               { 'for': ['asm', 'gas']     }
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript',     { 'for': ['js', 'jsx']      }
Plug 'leafgarland/typescript-vim',  { 'for': ['ts', 'tsx']      }
Plug 'MaxMEllon/vim-jsx-pretty',    { 'for': ['jsx', 'tsx']     }

if has("unix")
    if isdirectory($HOME . "/.nvm/versions/node/v15.11.0/bin/")
        let g:coc_node_path = $HOME . "/.nvm/versions/node/v15.11.0/bin/node"
        let g:coc_global_extensions = [ 'coc-tsserver' ]
        " TODO consider loading it manually for faster startup
        " (https://github.com/junegunn/vim-plug/wiki/tips#loading-plugins-manually)
        Plug 'neoclide/coc.nvim',   { 'branch': 'release'       }
    endif
endif


call plug#end()

autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


" Settings

" set vim-gas syntax for asm
au BufRead,BufNewFile *.asm set filetype=gas

" Highlight JSDocs
let g:javascript_plugin_jsdoc = 1

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
