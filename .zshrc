#
# History
#

[[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/zsh" ]] || mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

#
# Options
#

setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT
setopt NO_BG_NICE NO_HUP LONG_LIST_JOBS
setopt CORRECT

#
# Completion
#

fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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
alias delbr='git br | fzf -m | xargs git branch -D'
alias tf='terraform'
alias k='kubectl'

#
# Functions
#

dotf() { git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"; }

dj() {
    poetry run python manage.py "$@"
}

wt() {
    local new_branch="" base_branch="main" python_version="3.13"

    while [[ $# -gt 0 ]]; do
        case $1 in
            --new-branch) new_branch=$2; shift 2 ;;
            --base-branch) base_branch=$2; shift 2 ;;
            --python) python_version=$2; shift 2 ;;
            *) echo "Unknown option: $1"; return 1 ;;
        esac
    done

    if [[ -z $new_branch ]]; then
        echo "Usage: wt --new-branch <branch> [--base-branch <branch>] [--python <version>]"
        return 1
    fi

    git worktree add -b "$new_branch" "$new_branch" "$base_branch" || return 1
    cd "$new_branch" || return 1
    mise shell python@"$python_version"
    poetry env use "$(mise which python)"
    poetry install --with dev
    cp ../main/.env .
    sed -i '' "s/^\(DATABASE_URL=.*\)/\1-$new_branch/" .env
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

#
# Sources
#

source /opt/homebrew/Cellar/zsh-syntax-highlighting/0.8.0/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
source <(fzf --zsh)
source $HOME/.secrets/env

#
# Evals
#

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(mise activate zsh)"
