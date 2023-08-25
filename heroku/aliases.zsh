# Heroku CLI
alias h='TZ=UTC heroku'
function a() {
	app=$1
}
function ha() {
  heroku "$@" -a $app;
}
alias hb='hs run bash -a'
alias hl='hs logs -t -a'
