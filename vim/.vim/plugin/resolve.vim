" https://github.com/tpope/vim-fugitive/pull/814#issuecomment-446767081
"
" Allow resolving symlinks such that Fugitive can find and operate on the git
" directory for files that are symlinks to files in a git repository.
if exists('g:loaded_resolve')
	finish
endif
let g:loaded_resolve = 1

function! s:Resolve() abort
  let current = expand('%')
  let resolved = resolve(current)
  if current !~# '[\/][\/]' && current !=# resolved
    silent execute 'keepalt file' fnameescape(resolved)
    return 'edit'
  endif
  return ''
endfunction

command -bar Resolve execute s:Resolve()

augroup resolve
  autocmd!
  autocmd BufReadPost * nested
        \ if exists('*FugitiveExtractGitDir') && !exists('b:git_dir') &&
        \     expand('%') !=# resolve(expand('%')) &&
        \     len(FugitiveExtractGitDir(resolve(expand('%')))) |
        \   Resolve |
        \ endif
augroup END
