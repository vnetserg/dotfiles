# This file is sourced by all the user's zsh shells

# Oh-my-zsh configuration
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="bira-custom"

plugins=(
    git
    vi-mode
    history-substring-search
)

source $ZSH/oh-my-zsh.sh

# Enable history search
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Enable edit undo and redo
bindkey "^u" undo
bindkey "^r" redo

# Go to beggining/end of the line
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line

# Source aliases
source ${HOME}/.aliases

# Source envorinment variables
source ${HOME}/.env

# Z utility
source ${HOME}/.zsh/z/z.sh

# Make backspace work properly in vi mode
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line

# Time format
TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'
