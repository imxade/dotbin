#!/bin/zsh
#
# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
setopt autocd		# Automatically cd into typed directory.
setopt interactive_comments

# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME"/.history
export SAVEHIST=$HISTSIZE

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# prompt
autoload -Uz compinit promptinit
compinit
promptinit
# PROMPT='%1~ %(!.#.>) '

# theme

# hotkey to swallow
bindkey -s '^O' " & disown && exit\n"

# alias
. "$HOME"/.config/shell/alias
# nix
. "$HOME"/.config/shell/nix.sh
# theme
. "$HOME"/.themes/zsh/oxide.zsh-theme

