" Vundle init
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'mileszs/ack.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'nvie/vim-flake8'
Bundle 'Valloric/YouCompleteMe'

" Vundle teardown
call vundle#end()
filetype plugin indent on

" Set dark background
set background=dark

" Set escape timeout to zero
set timeoutlen=1000 ttimeoutlen=0

" Enable indentation plugin
filetype plugin indent on
" Show existing tab with 4 spaces width
set tabstop=4
" When indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" Show line numbers
set number

" Bind Ctrl+O to open file in a new tab
map <C-O> :tabe 

" Bind Ctrl+P to jump back (original function of Ctrl-O)
nnoremap <C-P> <C-O>

" Bind Ctrl+G to split
map <C-G> :vs 

" Bind Ctrl+A to Ack
map <C-A> :Ack 

" Bind Ctrl+J and Ctrl+K to switch between tabs
map <C-K> :tabn<CR>
map <C-J> :tabprev<CR>

" Bind Ctrl+H and Ctrl+L to switch between panes
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>

" Exit hotkey
map <C-X> :q<CR>

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

" Quickfix hotkeys
map <C-L> :cn<CR>
map <C-H> :cp<CR>
map ,q <Plug>window:quickfix:toggle

" Folding
set foldlevel=99
nnoremap <space> za

" YCM options
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_confirm_extra_conf = 0
map ,d :YcmCompleter GoToDefinitionElseDeclaration<CR>
map ,D :tab split \| YcmCompleter GoToDefinitionElseDeclaration<CR>
map ,r :YcmCompleter GoToReferences<CR>
map ,t :YcmCompleter GetType<CR>

" Pmenu look
hi Pmenu ctermfg=NONE ctermbg=236 cterm=NONE guifg=NONE guibg=#64666d gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=24 cterm=NONE guifg=NONE guibg=#204a87 gui=NONE

" Line length indicator
set colorcolumn=100
highlight ColorColumn ctermbg=0

" Python virtualenv
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" Flake8
let g:flake8_cmd="flake8 --ignore=E1,E3,E5"
autocmd BufWritePost *.py call Flake8()

" Duplicate tab pane
command! -bar DuplicateTabpane
      \ let s:sessionoptions = &sessionoptions |
      \ try |
      \   let &sessionoptions = 'blank,help,folds,winsize,localoptions' |
      \   let s:file = tempname() |
      \   execute 'mksession ' . s:file |
      \   tabnew |
      \   execute 'source ' . s:file |
      \ finally |
      \   silent call delete(s:file) |
      \   let &sessionoptions = s:sessionoptions |
      \   unlet! s:file s:sessionoptions |
      \ endtry

nnoremap ,n :DuplicateTabpane<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo
cmap w!! w !sudo tee > /dev/null %

" Etc
let python_highlight_all=1
syntax on

