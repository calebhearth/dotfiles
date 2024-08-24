setlocal formatprg=format-gitconfig
autocmd FileWritePre gitconfig silent! %!format-gitconfig
