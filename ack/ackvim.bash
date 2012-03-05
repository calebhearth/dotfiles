# Thanks to Michael Lange https://github.com/DingoEatingFuzz
# Ack for a search term and automatically open all files with results in vim.
function ackvim()
{
  echo 'Acking...';
  vim $(ack -l $*);
}