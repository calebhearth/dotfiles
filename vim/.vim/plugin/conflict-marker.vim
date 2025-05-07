let g:conflict_marker_begin = '^<<<<<<<\+ .*$'
let g:conflict_marker_common_ancestors = '^|||||||\+ .*$'
let g:conflict_marker_end   = '^>>>>>>>\+ .*$'
let g:conflict_marker_enable_mappings = 0
let g:conflict_marker_enable_matchit = 1

hi ConflictMarkerBegin guifg=#4493f8 guibg=#15233A gui=bold
hi ConflictMarkerOurs guibg=#15233A
hi ConflictMarkerCommonAncestors guifg=#db9500 guibg=#282119 gui=bold
hi ConflictMarkerCommonAncestorsHunk guibg=#282119
hi ConflictMarkerSeparator gui=bold
hi ConflictMarkerTheirs guibg=#002b08
hi ConflictMarkerEnd guibg=#002b08 guifg=#3bad4e gui=bold


hi gitCommitDiscardedType guifg=#c9d1d9 guibg=#282119
hi gitCommitDiscardedFile guifg=#c9d1d9 guibg=#282119 gui=bold
hi gitCommitSelectedType guifg=#c9d1d9 guibg=#182335
hi gitCommitSelectedFile guifg=#c9d1d9 guibg=#182335 gui=bold

hi diffOldFile guifg=#db9500 guibg=#282119 gui=bold
hi diffNewFile guifg=#4493f8 guibg=#15233A gui=bold
hi gitDiff guifg=#c9d1d9
hi DiffAdd guibg=#273C5B gui=bold
hi DiffRemoved guibg=#463023 gui=bold
hi DiffChange guibg=#15233A
hi DiffText guibg=#273C5B gui=bold
hi clear DiffDelete
hi link DiffDelete Ignore
hi Changed guibg=#002b08
hi Added guifg=#c9d1d9 guibg=#273C5B gui=bold
