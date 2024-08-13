#
# ENVIRONMENT VARIABLES:
#

# SSH
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# Common
export PATH="${HOME}/bin:${HOME}/.local/bin:${HOME}/.cargo/bin:${HOME}/code/go/bin:${PATH}"
export TERM=xterm-256color
export EDITOR=vim
export VIMINIT="source ${HOME}/.vimrc"

# Go
export GOPATH=${HOME}/code/go
export PATH=/usr/local/go/bin:$PATH

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --follow'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Virtualenv wrapper
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
# export WORKON_HOME=$HOME/.virtualenvs
# source $HOME/.local/bin/virtualenvwrapper.sh

#
# ALIASES:
#
alias za="zellij attach"
alias sudo="sudo "
alias vi="vim"
alias ls="ls -h --color=auto"
alias ag="ag --path-to-ignore ~/.agignore"
alias cmake="cmake -GNinja"
alias cmake-asan="cmake -DCMAKE_BUILD_TYPE=ASAN"
alias cmake-tsan="cmake -DCMAKE_BUILD_TYPE=TSAN"
if [ ! -f "$(which update-grub)" ]; then
    alias update-grub='bash -c "grub-mkconfig -o /boot/grub/grub.cfg.tmp && mv /boot/grub/grub.cfg.tmp /boot/grub/grub.cfg"'
fi
if [ -f "$(which pacman)" ]; then
    alias remove-orphans="pacman -Rns $(pacman -Qtdq)"
fi

# Yazi wrapper that changes cwd when exiting yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

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

# Enable edit undo and redo
bindkey "^u" undo
bindkey "^r" redo

# Go to beggining/end of the line
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line

# Make backspace work properly in vi mode
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char
bindkey "^U" backward-kill-line

# Z tool
source /home/se4min/.zsh/z/z.sh

# FZF widget
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^G' fzf-cd-widget

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
