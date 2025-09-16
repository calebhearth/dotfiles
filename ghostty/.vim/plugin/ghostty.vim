if exists('g:loaded_dispatch_ghostty')
	finish
endif

let g:loaded_dispatch_ghostty = 1

if has('nvim')
	augroup ghostty-dispatch-neovim
		autocmd!
		autocmd VimEnter *
			\ if index(get(g:, 'dispatch_handlers', ['ghostty']), 'ghostty') < 0 |
			\	call insert(g:dispatch_handlers, 'ghostty', 0) |
			\ endif
	augroup END
endif
