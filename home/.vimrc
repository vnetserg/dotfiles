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
Bundle 'Valloric/YouCompleteMe'
Plugin 'fatih/vim-go'
Plugin 'rust-lang/rust.vim'
Plugin 'w0rp/ale'
Plugin 'itchyny/lightline.vim'
Bundle 'christoomey/vim-tmux-navigator'

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

" YCM plugin
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_confirm_extra_conf = 0
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 0 
let g:ycm_enable_diagnostic_highlighting = 0
nnoremap ,d :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap ,D :vsplit \| YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap ,r :YcmCompleter GoToReferences<CR>
nnoremap ,T :YcmCompleter GetType<CR>
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE

" Go plugin
let g:go_version_warning = 0

" ALE plugin
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
let g:ale_lint_on_insert_leave = 0
let g:ale_linters = {
\   'cpp': [],
\   'proto': [],
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

" Quickfix toggling
if exists("g:__QUICKFIX_TOGGLE_jfklds__")
    finish
endif
let g:__QUICKFIX_TOGGLE_jfklds__ = 1
fun! s:QuickfixToggle() "{{{
    let nr = winnr("$")
    cwindow
    let nr2 = winnr("$")
    if nr == nr2
        cclose
    endif
endfunction "}}}
nnoremap <silent> <Plug>window:quickfix:toggle :call <SID>QuickfixToggle()<CR>
nnoremap ,q <Plug>window:quickfix:toggle

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
