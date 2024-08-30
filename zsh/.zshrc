if command -v brew 2>&1 > /dev/null; then
  local chruby="$(brew --prefix)/share/chruby"
	if [ -d "$chruby" ]; then
		source "$chruby/chruby.sh"
		source "$chruby/auto.sh"
    chruby .
	fi
  local gemHome="$(brew --prefix)/share/gem_home"
	if [ -d "$gemHome" ]; then
		source "$gemHome/gem_home.sh"
		gem_home $HOME
	fi
fi

typeset -U path PATH
typeset -U fpath FPATH

if command -v brew 2>&1 > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  fpath=($(brew --prefix)/share/zsh/site-functions ${fpath})
  export MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH"
fi
export PATH="$HOME/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin:/sbin"

export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt INC_APPEND_HISTORY # adds history incrementally
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_REDUCE_BLANKS

setopt extended_glob

setopt complete_aliases
unsetopt nomatch

alias ag='echo "Use rg instead of ag"'
function rg() {
	command rg --smart-case --json "$@" | delta
}
function a() {
	app=$1
}
function ha() {
  heroku "$@" -a $app;
}

# initialize autocomplete here, otherwise functions won't be loaded
fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -U compinit && compinit

autoload edit-command-line
zle -N edit-command-line
bindkey "^X" edit-command-line

export WORDCHARS="${WORDCHARS:s#/#}"
cdpath=(. ~/code ~/books)

# handy keybindings
bindkey "^A" beginning-of-line
bindkey "^F" forward-word
bindkey "^B" backward-word
bindkey "^E" end-of-line
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[S" # "t" for "toughguy"
bindkey "^[[3~" delete-char # delete forward
bindkey '[[Z' reverse-menu-complete

ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

command -v direnv 2>&1 > /dev/null && eval "$(direnv hook zsh)"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

source ~/.dotfiles/git_prompt.sh
source ~/.dotfiles/zsh_prompt.sh
eval "$(atuin init zsh --disable-up-arrow)"
