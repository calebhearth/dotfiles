" https://github.com/SevereOverfl0w/.files/blob/3d7670366931a3428742890d0f63620e972743c7/dotfiles/.config/nvim/plugin/kitty.vim
if exists('g:loaded_dispatch_kitty')
	finish
endif

let g:loaded_dispatch_kitty = 1

if has('nvim')
	augroup kitty-dispatch-neovim
		autocmd!
		autocmd VimEnter *
			\ if index(get(g:, 'dispatch_handlers', ['kitty']), 'kitty') < 0 |
			\	call insert(g:dispatch_handlers, 'kitty', 0) |
			\ endif
	augroup END
endif
