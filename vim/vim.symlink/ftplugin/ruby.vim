vnoremap <Leader>i :call I18nTranslateString()<CR>
setlocal keywordprg=:Dispatch\ ri

:ALEDisable

autocmd BufWritePre *.rb :lua vim.lsp.buf.format { async = false }
autocmd FileWritePre *.rb :lua vim.lsp.buf.format { async = false }

let g:tagbar_type_ruby = {
  \ 'kinds' : [
    \ 'm:modules',
    \ 'c:classes',
    \ 'd:describes',
    \ 'C:contexts',
    \ 'f:methods',
    \ 'F:singleton methods'
  \ ]
\ }
