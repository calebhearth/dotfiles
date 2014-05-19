setopt PROMPT_SUBST
GIT_PS1_DESCRIBE_STYLE=branch
GIT_PS1_SHOWUPSTREAM="auto git"
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWDIRTYSTATE=1

precmd () {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    toplevel=$(git rev-parse --show-toplevel)
    psvar[1]=$(basename $toplevel)
    psvar[2]=${PWD#$toplevel}
  else
    psvar[1]=`pwd`
    psvar[2]=''
  fi
  __git_ps1 "%1v" "%2v ❯ " "(%s)"
}
