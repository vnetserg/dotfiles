scriptencoding utf-8

" Vundle init
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

set rtp+=~/.fzf " FZF stock plugin

" Vundle plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'dense-analysis/ale'
Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'deoplete-plugins/deoplete-jedi'
Plugin 'deoplete-plugins/deoplete-clang'
Plugin 'Shougo/neoinclude.vim'
Plugin 'itchyny/lightline.vim'
Bundle 'christoomey/vim-tmux-navigator'
Plugin 'drmingdrmer/vim-toggle-quickfix'

" Vundle teardown
call vundle#end()

" Ack plugin
let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.agignore'
nnoremap ,a :Ack! "\b<cword>\b"<CR>
nnoremap <C-A> :Ack! 

" FZF plugin
nnoremap ,b :Buffers<CR>
nnoremap ; :Files<CR>

" ALE plugin
let g:ale_set_highlights = 0
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_completion_enabled = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_keep_list_window_open = 1
let g:ale_python_flake8_options = '--ignore=E1,E3,E5,E7,E203,E226'
let g:ale_python_pyls_executable = '/home/se4min/bin/pyls'
let g:ale_python_pyls_config = {
\   'pyls': {
\       'plugins': {
\           'pycodestyle': {'enabled': v:true, 'ignore': ['E1', 'E3', 'E5', 'E7', 'E203', 'E226']},
\           'mccabe': {'enabled': v:false},
\           'pylint': {'enabled': v:false},
\        }
\    }
\}
let g:ale_linters = {
\   'cpp': ['ccls'],
\   'proto': [],
\   'rust': ['rls'],
\   'python': ['pyls'],
\}

nnoremap ,d :ALEGoToDefinition<CR>
nnoremap ,D :vsplit \| ALEGoToDefinition<CR>
nnoremap ,t :ALEGoToTypeDefinition<CR>
nnoremap ,T :vsplit \| ALEGoToTypeDefinition<CR>
nnoremap ,r :ALEFindReferences<CR>
nnoremap ,h :ALEHover<CR>

" Disable ALE linting in cpp files
autocmd FileType cpp call s:cpp_disable_linting()
autocmd FileType c call s:cpp_disable_linting()
function! s:cpp_disable_linting()
    setlocal scl=no
endfunction

" Deoplete autocompletion
let g:deoplete#sources#clang#libclang_path = '/usr/lib/x86_64-linux-gnu/libclang-8.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-8/lib/clang'
let g:deoplete#enable_at_startup = 1
set shortmess+=c " Disable 'pattern not found'
set completeopt-=preview " Disable preview window

" Autocompletion bar settings
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

" Lightline plugin
let g:lightline = {
    \     'colorscheme': 'seoul256',
    \     'active': {
    \         'left': [ [ 'mode', 'paste' ], [ 'readonly', 'relativepath', 'modified' ] ],
    \     }
    \ }

" Vim-Tmux plugin
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <Esc>h :TmuxNavigateLeft<cr>
nnoremap <silent> <Esc>j :TmuxNavigateDown<cr>
nnoremap <silent> <Esc>k :TmuxNavigateUp<cr>
nnoremap <silent> <Esc>l :TmuxNavigateRight<cr>

" Quickfix toggle plugin
nmap ,q <Plug>window:quickfix:loop

" Other hotkeys
nnoremap <C-P> <C-O>
nnoremap <C-H> :lprev<CR>
nnoremap <C-L> :lnext<CR>
nnoremap <Esc>g :vsplit<CR><C-w>l<CR>
nnoremap <Esc>v :split<CR><C-w>j<CR>
nnoremap <C-O> :edit 
nnoremap <Backspace> <C-^>
nnoremap <C-X> :q<CR>
nnoremap <C-J> :cn<CR>
nnoremap <C-K> :cp<CR>

" Styling
syntax on
set number
set noshowmode
set background=dark
set fillchars+=vert:│
set colorcolumn=100
set laststatus=2
highlight ColorColumn ctermbg=0
highlight VertSplit cterm=none
autocmd VimResized * wincmd =

" Controls
set timeoutlen=1000 ttimeoutlen=0
set tabstop=4
set shiftwidth=4
set expandtab
filetype plugin indent on

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Auto-activate Python virtualenv
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" Allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! w !sudo tee > /dev/null %

" Etc
set encoding=utf-8
set noswapfile
