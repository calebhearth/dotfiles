function s:overrideHighlights()
  " #273C5B hsl(215.77 40% 25%) oklch(0.35 0.0606 257.97)
  " #4493f8 hsl(213.67 93% 62%) oklch(0.66 0.1692 255.92)
  highlight clear Added
  highlight Added guifg=#c9d1d9 guibg=#273C5B gui=bold
  highlight! default link GitNew Added
  highlight! default link diffAdded Added
  highlight! default link diffAdd Added
  highlight! default link DiffText Added

  highlight clear GitSignsAdd
  highlight GitSignsAdd guifg=#4493f8 guibg=clear
  highlight! default link gitCommitDiscardedFile GitSignsAdd
  highlight! default link gitCommitDiscardedType GitSignsAdd

  highlight diffNewFile guifg=#4493f8 guibg=#15233A gui=bold


  " #463023 oklch(0.33 0.039 51.54)
  " #d29922 oklch(0.72 0.1401 79.91)
  highlight GitDeleted guifg=#c9d1d9 guibg=#463023 gui=bold
  highlight! link diffRemoved GitDeleted
  highlight! link DiffDelete GitDeleted

  highlight GitSignsChange guifg=#d29922 guibg=clear
  highlight! link gitCommitSelectedFile GitSignsChange
  highlight! link gitCommitSelectedType GitSignsChange
  highlight gitCommitBranch guifg=#db9500 guibg=#463023 gui=bold
  highlight diffOldFile guifg=#db9500 guibg=#282119 gui=bold

  " #38af00 oklch(0.66 0.2372 137.54)
  " #104900 oklch(0.35 0.1267 137.54)
  highlight clear Changed
  highlight Changed guifg=#c9d1d9 guibg=#214610 gui=bold
  highlight! link GitDirty Changed
  highlight! link DiffChange Changed

  highlight! link gitCommitHeader Comment

  highlight gitMeta guifg=#a16c00 guibg=clear
  highlight link diffNewFile gitMeta
  highlight link diffOldFile gitMeta
  highlight link diffOldFile gitMeta
  highlight link diffIndexLine gitMeta
  highlight link diffFile gitMeta

  hi gitDiff guifg=#c9d1d9
  " hi clear DiffDelete
  " hi link DiffDelete Ignore
endfunction

augroup diffcolors
  autocmd!
  autocmd ColorScheme * call <SID>overrideHighlights()
augroup END
call s:overrideHighlights()
