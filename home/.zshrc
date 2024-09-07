# Activate vim mode.
bindkey -v

#
# ENVIRONMENT VARIABLES:
#

# SSH
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# Common
export PATH="${HOME}/bin:${HOME}/.local/bin:${HOME}/.cargo/bin:${HOME}/code/go/bin:${PATH}"
export TERM=xterm-256color
export EDITOR=hx
export VIMINIT="source ${HOME}/.vimrc"

# Go
export GOPATH=${HOME}/code/go
export PATH=/usr/local/go/bin:$PATH

#
# ALIASES:
#
alias za="zellij attach"
alias sudo="sudo "
alias vi="vim"
alias ls="ls -h --color=auto"

# Yazi wrapper that changes cwd when exiting yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
bindkey -s '^Y' 'yy^M'

#
# PLUGINS:
#

# Oh-my-zsh configuration
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="robbyrussell-custom"
plugins=(
    git
    vi-mode
    history-substring-search
)
source $ZSH/oh-my-zsh.sh

# Enable history search
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Zoxide
eval "$(zoxide init zsh)"

# FZF
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
bindkey '^F' fzf-file-widget
bindkey '^W' fzf-cd-widget
bindkey '^R' fzf-history-widget

# Time format
export TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

# Private part
if [ -f ~/.zshrc.ya ]; then
    source ~/.zshrc.ya
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

#
# Vim mode configuration.
#

# Remove mode switching delay.
KEYTIMEOUT=5

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'

  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# Use beam shape cursor on startup.
echo -ne '\e[5 q'

# Use beam shape cursor for each new prompt.
precmd_vim_cursor() {
   echo -ne '\e[5 q'
}
precmd_functions+=(precmd_vim_cursor)
