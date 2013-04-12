if [[ ! -o interactive ]]; then
    return
fi

compctl -K _vundle vundle

_vundle() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(vundle commands)"
  else
    completions="$(vundle completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
