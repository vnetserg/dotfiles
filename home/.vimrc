scriptencoding utf-8

" Vundle init
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

set rtp+=~/contrib/fzf " FZF stock plugin

" Vundle plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'dense-analysis/ale'
Plugin 'Shougo/deoplete.nvim'
Plugin 'roxma/nvim-yarp'
Plugin 'roxma/vim-hug-neovim-rpc'
Plugin 'deoplete-plugins/deoplete-jedi'
Plugin 'deoplete-plugins/deoplete-clang'
Plugin 'sebastianmarkow/deoplete-rust'
Plugin 'Shougo/neoinclude.vim'
Plugin 'itchyny/lightline.vim'
Bundle 'christoomey/vim-tmux-navigator'
Plugin 'drmingdrmer/vim-toggle-quickfix'
Plugin 'preservim/nerdtree'

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
let g:ale_set_highlights = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 1
let g:ale_completion_enabled = 0
let g:ale_keep_list_window_open = 1
let g:ale_python_flake8_options = '--ignore=E1,E3,E5,E7,E203,E226'
let g:ale_cpp_clangd_executable = 'clangd-9'
let g:ale_python_pyls_config = {
\   'pyls': {
\       'plugins': {
\           'pycodestyle': {'enabled': v:true, 'ignore': ['E1', 'E3', 'E5', 'E7', 'E203', 'E226', 'W503']},
\           'mccabe': {'enabled': v:false},
\           'pylint': {'enabled': v:false},
\        }
\    }
\}
let g:ale_linters = {
\   'cpp': ['clangd'],
\   'c': [],
\   'asm': [],
\   'proto': [],
\   'rust': ['rls'],
\   'python': ['pyls', 'flake8'],
\}

nnoremap ,d :ALEGoToDefinition<CR>
nnoremap ,D :vsplit \| ALEGoToDefinition<CR>
nnoremap ,t :ALEGoToTypeDefinition<CR>
nnoremap ,T :vsplit \| ALEGoToTypeDefinition<CR>
nnoremap ,r :ALEFindReferences<CR>
nnoremap ,h :ALEHover<CR>

" Deoplete autocompletion
let g:deoplete#sources#clang#libclang_path = '/usr/lib/x86_64-linux-gnu/libclang-8.so.1'
let g:deoplete#sources#clang#clang_header = '/usr/lib/llvm-8/lib/clang'
let g:deoplete#enable_at_startup = 1
set shortmess+=c " Disable 'pattern not found'
set completeopt-=preview " Disable preview window
set completeopt+=noinsert,noselect " Against too eager autocompletion

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
    \     },
    \     'inactive': {
    \         'left': [ [ 'relativepath' ] ],
    \     }
    \ }

" Vim-Tmux plugin
let g:tmux_navigator_no_mappings = 1
let g:tmux_navigator_disable_when_zoomed = 1
nnoremap <silent> <A-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <A-j> :TmuxNavigateDown<cr>
nnoremap <silent> <A-k> :TmuxNavigateUp<cr>
nnoremap <silent> <A-l> :TmuxNavigateRight<cr>

" Quickfix toggle plugin
nmap ,q <Plug>window:quickfix:loop

" Other hotkeys
nnoremap <C-P> <C-O>
nnoremap <C-H> :lprev<CR>
nnoremap <C-L> :lnext<CR>
nnoremap <A-g> :vsplit<CR><C-w>l<CR>
nnoremap <A-v> :split<CR><C-w>j<CR>
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
highlight SignColumn ctermbg=black
highlight VertSplit cterm=none
highlight ALEError ctermbg=none cterm=underline
highlight ALEWarning ctermbg=none cterm=underline
highlight ALEErrorSign ctermbg=none ctermfg=red
highlight ALEWarningSign ctermbg=none ctermfg=yellow
autocmd VimResized * wincmd =

" Cursor line highlight
hi CursorLine   cterm=NONE ctermbg=black
hi CursorColumn cterm=NONE ctermbg=black
" hlight current line current window only
augroup CursorLine
    au!
    au VimEnter,WinEnter,BufWinEnter,FocusGained,CmdwinEnter * setlocal cursorline
    au WinLeave,FocusLost,CmdwinLeave * setlocal nocursorline
augroup END

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
set nohlsearch
