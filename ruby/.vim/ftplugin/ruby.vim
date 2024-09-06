vnoremap <Leader>i :call I18nTranslateString()<CR>
setlocal keywordprg=:Dispatch\ ri

augroup ruby
  autocmd!
  autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = false, timeout_ms = 500 }
augroup END

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
let ruby_operators = 1
let ruby_pseudo_operators = 1
let ruby_space_errors = 1
let ruby_line_continuation_error = 1
let ruby_global_variable_error   = 1
let ruby_spellcheck_strings = 1
