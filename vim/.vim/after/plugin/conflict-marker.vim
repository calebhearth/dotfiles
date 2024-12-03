syntax include @DiffSyntax syntax/diff.vim
execute printf('syntax region ConflictMarker containedin=ALL start=/%s/hs=e+1 end=/%s\&/ keepend contains=ConflictMarkerOurs,ConflictMarkerCommonAncestors,ConflictMarkerCommonAncestorsHunk,ConflictMakerSeparator,ConflictMarkerTheirs contains=@DiffSyntax', g:conflict_marker_begin, g:conflict_marker_separator)
