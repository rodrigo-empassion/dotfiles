#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ -z "$BROWSER" && "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

#
# Editors
#

if [[ -z "$EDITOR" ]]; then
  export EDITOR='nvim'
fi
if [[ -z "$VISUAL" ]]; then
  export VISUAL='nvim'
fi
if [[ -z "$PAGER" ]]; then
  export PAGER='less'
fi

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  $HOME/dev/scripts/bin
  $HOME/.local/bin
  $HOME/.yarn/bin
  $HOME/{,s}bin(N)
  /opt/{homebrew,local}/{,s}bin(N)
  /usr/local/{,s}bin(N)
  $path
)

fpath=(
    /opt/homebrew/share/zsh/site-functions
    $fpath
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X to enable it.
if [[ -z "$LESS" ]]; then
  export LESS='-g -i -M -R -S -w -X -z-4'
fi

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if [[ -z "$LESSOPEN" ]] && (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# 
# fzf
#

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
export FZF_DEFAULT_OPTS="
	--color=fg:#908caa,bg:#191724,hl:#ebbcba
	--color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
	--color=border:#403d52,header:#31748f,gutter:#191724
	--color=spinner:#f6c177,info:#9ccfd8
	--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

#
# bat
#

export BAT_THEME='rose-pine'

#
# java
#

export JAVA_HOME=/opt/homebrew/Cellar/openjdk@17/17.0.12/libexec/openjdk.jdk/Contents/Home

#
# gcp
#

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"

#
# zsh-vi-mode
#

export ZVM_INIT_MODE=sourcing

#
# scripts
#

export SCRIPTS_LIB_DIR="$HOME/dev/scripts/lib"
