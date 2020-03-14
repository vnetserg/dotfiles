scriptencoding utf-8
set nocompatible
filetype off

" Plug init
call plug#begin('~/.vim/plugged')

" Plugins
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'Shougo/deoplete.nvim'
Plug 'itchyny/lightline.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'drmingdrmer/vim-toggle-quickfix'
Plug 'vim-scripts/indentpython.vim'
Plug 'preservim/nerdtree'

" Initialize plugin system
call plug#end()

" Ack plugin
let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.agignore'
nnoremap ,a :Ack! "\b<cword>\b"<CR>
nnoremap <C-A> :Ack! 

" FZF plugin
nnoremap ,b :Buffers<CR>
nnoremap ; :Files<CR>

" LanguageClient plugin
set hidden " Required for operations modifying multiple buffers like rename.
let g:LanguageClient_settingsPath = '~/.vim/settings.json'
let g:LanguageClient_useVirtualText = 'No'
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rls'],
    \ 'python': ['~/.local/bin/pyls'],
    \ 'cpp': ['/usr/bin/clangd-9', '-header-insertion=never', '--clang-tidy',
    \         '--all-scopes-completion', '--background-index'],
    \ }
let g:LanguageClient_diagnosticsDisplay = {
\   1: { 'signText': '>>' },
\   2: { 'signText': '--' },
\}

nnoremap <silent> ,h :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> ,d :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> ,D :vsplit \| :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> ,t :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <silent> ,T :vsplit \| :call LanguageClient#textDocument_typeDefinition()<CR>
nnoremap <silent> ,R :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> ,r :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> ,f :call LanguageClient#textDocument_codeAction()<CR>:sleep 10m<CR><CR>
nnoremap <silent> ,F :call LanguageClient#textDocument_codeAction()<CR>
nnoremap <silent> ,/ :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <silent> ,s :call LanguageClient#workspace_symbol()<CR>
nnoremap <silent> ,c :sign unplace *<CR>


" Deoplete autocompletion
let g:deoplete#enable_at_startup = 1
set shortmess+=c " Disable 'pattern not found'
set completeopt-=preview " Disable preview window
set completeopt+=noinsert,noselect " Against too eager autocompletion

" Autocompletion bar settings
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

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
nnoremap <A-g> :vsplit<CR>
nnoremap <A-v> :split<CR>
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
highlight SignColumn ctermbg=none
highlight VertSplit cterm=none
highlight ALEError ctermbg=none cterm=none
highlight ALEWarning ctermbg=none cterm=none
highlight ALEErrorSign ctermbg=none ctermfg=red cterm=bold
highlight ALEWarningSign ctermbg=none ctermfg=yellow cterm=bold
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
cmap W! w!

" Etc
set encoding=utf-8
set noswapfile
set nohlsearch
