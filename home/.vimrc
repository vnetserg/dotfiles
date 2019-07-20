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
Plugin 'tmhedberg/SimpylFold'
Plugin 'bufkill.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'fatih/vim-go'
Plugin 'rust-lang/rust.vim'
Plugin 'w0rp/ale'
Plugin 'itchyny/lightline.vim'
Bundle 'christoomey/vim-tmux-navigator'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'prabirshrestha/asyncomplete-file.vim'
Plugin 'prabirshrestha/asyncomplete-buffer.vim'
Plugin 'drmingdrmer/vim-toggle-quickfix'

" Vundle teardown
call vundle#end()

" Ack plugin
let g:ackprg = 'ag --vimgrep --path-to-ignore ~/.agignore'
nnoremap ,a :Ack! "\b<cword>\b"<CR>
nnoremap <C-A> :Ack! 

" SimplyFold plugin
set foldlevel=99
nnoremap <space> za

" Bufkill plugin - close buffer hotkey
nnoremap <C-W> :BD<CR>

" FZF plugin
nnoremap ,b :Buffers<CR>
nnoremap ; :Files<CR>
nnoremap ,t :Tags<CR>

" Go plugin
let g:go_version_warning = 0

" ALE plugin
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_python_flake8_options = '--ignore=E1,E3,E5,E7,E203,E226'
let g:ale_linters = {
\   'cpp': [],
\   'proto': [],
\   'rust': ['rls'],
\}

" Lightline plugin
let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ }

" Vim-Tmux plugin
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <Esc>h :TmuxNavigateLeft<cr>
nnoremap <silent> <Esc>j :TmuxNavigateDown<cr>
nnoremap <silent> <Esc>k :TmuxNavigateUp<cr>
nnoremap <silent> <Esc>l :TmuxNavigateRight<cr>

" Vim-lsp plugin
au User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': {server_info->['pyls']},
    \ 'whitelist': ['python'],
    \ })
au User lsp_setup call lsp#register_server({
    \ 'name': 'rls',
    \ 'cmd': {server_info->['rls']},
    \ 'whitelist': ['rust'],
    \ })
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))
nnoremap ,d :LspDefinition<CR>
nnoremap ,D :vsplit \| LspDefinition<CR>
nnoremap ,r :LspReferences<CR>
nnoremap ,h :LspHover<CR>
nnoremap ,s :LspWorkspaceSymbol 
let g:lsp_diagnostics_enabled = 0
let g:lsp_highlight_references_enabled = 0

" Asyncomplete plugin
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
set shortmess+=c

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
