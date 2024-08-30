export GITHUB_PERSONAL_TOKEN=2663e57f9d9049fc14f2f04f7432a08d4bfafe4c

export GHC_OPTIONS="-j4 +RTS -A128m -n2m -RTS"
export FAST_GHC_OPTIONS=$GHC_OPTIONS
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
