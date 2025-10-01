let g:markdown_fenced_languages = ['ruby', 'erb=eruby', 'sh', 'shell=sh', 'zsh=sh', 'bash=sh', 'sql', 'json']
let g:markdown_syntax_conceal = v:true
let g:markdown_yaml_head = v:true

" Extract the text under cursor surrounded by [] to a markdown link.
" https://calebhearth.com/literate-vim
nnoremap <Leader>e :normal mm"wya]}h2] 2j"wpa: <https://example.com><Esc>vi>p`m
" write the file and print word count (wc)
nnoremap <Buffer> ? :silent w !wc<CR>
vnoremap <Buffer> ? :'<,'>silent w !wc<CR>

setlocal keywordprg=:Dispatch\ dict
setlocal spell wrap linebreak nolist textwidth=0 conceallevel=3
