vnoremap <Leader>i :call I18nTranslateString()<CR>
setlocal keywordprg=:Dispatch\ ri

autocmd FileWritePre,BufWritePre *.rb :lua vim.lsp.buf.format { async = true }

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
