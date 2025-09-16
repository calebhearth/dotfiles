vnoremap <Leader>i :call I18nTranslateString()<CR>
nnoremap <C-/> /\v(def (self.)?)@<=
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

let b:splitjoin_trailing_comma = 1
let b:splitjoin_mapping_fallback = 0
let b:splitjoin_curly_brace_padding = 1
let b:splitjoin_ruby_curly_braces = 0
let b:splitjoin_ruby_trailing_comma = 1
let b:splitjoin_ruby_hanging_args = 0
let b:splitjoin_ruby_options_as_arguments = 1
let b:splitjoin_html_attributes_bracket_on_new_line = 1
let b:splitjoin_java_argument_split_first_newline = 1
let b:splitjoin_java_argument_split_last_newline  = 1
let b:splitjoin_c_argument_split_first_newline = 1
let b:splitjoin_c_argument_split_last_newline  = 1
