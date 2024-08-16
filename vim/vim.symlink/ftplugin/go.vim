let g:go_fmt_command = "goimports"
autocmd FileType go compiler go
autocmd FileType go nnoremap <Leader>t :Dispatch go test ./...<CR>
autocmd FileType go,zsh,bash,sh setlocal listchars=tab:\ \ ,trail:·,extends:> " Highlight problematic whitespace
autocmd FileType go,godoc setlocal keywordprg=:GoDoc
