alias ln='ln -v'

alias vimm='vim `git status -s | egrep -v "\s*D" | cut -d " " -f 3- | selecta`'
