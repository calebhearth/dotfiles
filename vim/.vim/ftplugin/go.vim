let g:go_fmt_command = "goimports"
autocmd FileType go compiler go
autocmd FileType go,zsh,bash,sh setlocal noexpandtab listchars=tab:\ \ ,trail:·,extends:> " Highlight problematic whitespace
autocmd FileType go,godoc setlocal keywordprg=:GoDoc

highlight link goConst Function
