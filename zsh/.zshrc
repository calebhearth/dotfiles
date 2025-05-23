typeset -U path PATH
typeset -U fpath FPATH

if command -v brew 2>&1 > /dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  fpath=($(brew --prefix)/share/zsh/site-functions ${fpath})
  export MANPATH="$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH"
fi
export PATH="$HOME/bin:$HOME/.cargo/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin:/sbin"

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
  if [[ "$-" == *i* ]]; then
    command rg --smart-case --line-number --heading --color=always "$@" | less --quit-if-one-screen --RAW-CONTROL-CHARS --no-init
  else
    command rg --smart-case "$@"
  fi
}

function a() {
	app=$1
}
function ha() {
  heroku "$@" -a $app;
}

# initialize autocomplete here, otherwise functions won't be loaded
fpath=(~/.local/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit

autoload -Uz edit-command-line
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

# source ~/.dotfiles/git_prompt.sh
# source ~/.dotfiles/zsh_prompt.sh
precmd() {
  ~/bin/jobs "$(printf '%s^^^' "${jobstates[@]}")" "$(printf '%s^^^' "${jobtexts[@]}")" "$(printf '%s^^^' "${jobdirs[@]}")"
}
eval "$(starship init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(mise activate zsh)"
