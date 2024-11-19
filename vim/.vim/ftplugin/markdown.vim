let g:markdown_fenced_languages = ['ruby', 'erb=eruby']

" Extract the text under cursor surrounded by [] to a markdown link.
" https://calebhearth.com/literate-vim
nnoremap <Leader>e :normal mm"wya]}h2] 2j"wpa: <https://example.com><Esc>vi>p`m
" write the file and print word count (wc)
nnoremap ? :silent w !wc<CR>
vnoremap ? :'<,'>silent w !wc<CR>

setlocal keywordprg=:Dispatch\ dict
setlocal spell wrap linebreak nolist textwidth=0
TSContextDisable
