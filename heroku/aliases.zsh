# Heroku CLI
alias h='TZ=UTC heroku'
function hs() {
  if [ -z "$reason" ]; then
    TZ=UTC heroku sudo "$@"
  else
    TZ=UTC heroku sudo "$@" --reason "$reason"
  fi
}
function a() {
	app=$1
}
function hsb() {
  if [ -z "$1" ]; then
    heroku sudo:run bash
  else
    if [ -z "$2" ]; then
      app="$1" heroku sudo:run bash
    else
      app="$1" reason="$2" heroku sudo:run bash
    fi
  fi
}
function hsa() {
if [ -z "$reason" ]; then
  hs "$@" -a $app;
else
  hs "$@" -a $app --reason "$reason";
fi
}
alias hb='hs run bash -a'
alias hba='hsa run bash'
alias hl='hs logs -t -a'
alias hla='hsa logs -t'
