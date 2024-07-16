if command -v brew 2>&1 > /dev/null; then
	if [ -d "/opt/homebrew/share/chruby" ]; then
		source /opt/homebrew/share/chruby/chruby.sh
		source /opt/homebrew/share/chruby/auto.sh
	fi
	if [ -d "/opt/homebrew/share/gem_home" ]; then
		source /opt/homebrew/share/gem_home/gem_home.sh
		gem_home $HOME
	fi
fi

export LC_ALL=en_US.UTF-8
export PATH="$HOME/bin:/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin:/sbin"
export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"

# shortcut to this dotfiles path is $ZSH
export ZSH=$HOME/.dotfiles

setopt complete_aliases
unsetopt nomatch

# all of our zsh files
typeset -U config_files
config_files=($ZSH/**/*.zsh)

source $ZSH/git/prompt.sh

# load the path files
for file in ${(M)config_files:#*/path.zsh}
do
	source $file
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}
do
	source $file
done

# initialize autocomplete here, otherwise functions won't be loaded
fpath=($ZSH/zsh/completions $fpath)
# heroku autocomplete setup
CLI_ENGINE_AC_ZSH_SETUP_PATH="$HOME/Library/Caches/heroku/completions/zsh_setup" && test -f $CLI_ENGINE_AC_ZSH_SETUP_PATH && source $CLI_ENGINE_AC_ZSH_SETUP_PATH;

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}
do
	source $file
done
autoload -U compinit
compinit

unset config_files

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

alias vim=nvim
ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

command -v direnv 2>&1 > /dev/null && eval "$(direnv hook zsh)"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(atuin init zsh --disable-up-arrow)"
