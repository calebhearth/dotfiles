#!/usr/bin/env zsh
set -eu
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

make --silent Brewfile.d Gemfile.d data_dir="$tmp" > /dev/null

for p in $(cat "$tmp/packages"); do
  if [[ -f "$p/Brewfile" && ! -L "$tmp/Brewfile.d/$p" ]]; then
    echo "Brewfile.d is missing $p" >&2
    exit 1
  fi
  if [[ -f "$p/Gemfile" && ! -L "$tmp/Gemfile.d/$p" ]]; then
    echo "Gemfile.d is missing $p" >&2
    exit 1
  fi
done
