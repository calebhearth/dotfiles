# colors!
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

alias wtc="curl -s 'http://whatthecommit.com/' | grep '<p>' | cut -c4-"
