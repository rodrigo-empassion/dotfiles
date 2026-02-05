#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

#
# Aliases
#

alias c='bat'
alias cp='nocorrect cp'
alias rm='nocorrect rm'
alias l='eza'
alias ls='eza'
alias la='eza -a'
alias ll='eza -l'
alias g='git'
alias upd='brew update && brew upgrade'
alias dotf='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias delbr="git br | fzf -m | xargs git branch -D"
alias tf='terraform'
alias k='kubectl'

#
# Functions
#

dj() {
    poetry run python manage.py "$@"
}

_dj() {
    local commands
    local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/django_completions_cache"

    if [[ -f "$cache_file" ]]; then
        commands=$(cat "$cache_file")
    else
        commands=$(poetry run python manage.py help | awk '/^  / {print $1}')
        echo "$commands" > "$cache_file"
    fi

    _arguments "1::command:($commands)"
}

compdef _dj dj

_fzf_git_checkout() {
    git branch --all --color=never | sed 's/.*\///' | fzf --preview "git log --oneline --graph --abbrev-commit --color=always {1}" | sed 's/^[ *]*//'
}

zstyle ':completion::git::checkout' completer _fzf_git_checkout

#
# Sources
#

source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source '/opt/homebrew/share/google-cloud-sdk/completion.zsh.inc'
source <(fzf --zsh)
source $HOME/.secrets

#
# Evals
#

eval "$(zoxide init zsh)"

#
# spaceship
#
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_PREFIX="at "
SPACESHIP_TIME_SUFFIX=" "
SPACESHIP_TIME_FORMAT="%D{%H:%M:%S}"
