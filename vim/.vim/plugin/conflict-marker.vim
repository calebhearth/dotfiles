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
