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
alias f='fasd -f'
alias l='eza'
alias ls='eza'
alias la='eza -a'
alias ll='eza -l'
alias g='git'
alias upd='brew update && brew upgrade'
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

#
# Functions
#

dj() {
    poetry run python manage.py "$@"
}

_dj() {
    local commands
    commands=$(poetry run python manage.py help | awk '/^  / {print $1}')
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
source <(fzf --zsh)

#
# nvm
#

autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

nvm use default
