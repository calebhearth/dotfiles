# Easier database pulls from heroku
function heroku-pull {
  heroku db:pull --app $1 --confirm $1 \
    `echo "postgres://$(whoami):$(whoami)@localhost/solmarket_dev_$(whoami)"` $*
}