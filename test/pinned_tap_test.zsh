#!/usr/bin/env zsh
set -eu
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

make --silent pinned_tap pinned_tap="$tmp/tap" HOME="$tmp/home" > /dev/null

[[ "$tmp/tap/Formula/beads.rb" -ef beads/Formula/beads.rb ]] || {
  echo "beads.rb was not hard-linked into the tap" >&2
  exit 1
}
