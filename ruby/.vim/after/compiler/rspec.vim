let s:cpo_save = &cpoptions
set cpoptions-=C

# Remove warnings from the original vim-ruby plugin
CompilerSet errorformat=
    \%E%.%#:in\ `load':\ %f:%l:%m,
    \%E%f:%l:in\ `%*[^']':\ %m,
    \%-Z\ \ \ \ \ %\\+\#\ %f:%l:%.%#,
    \%E\ \ \ \ \ Failure/Error:\ %m,
    \%E\ \ \ \ \ Failure/Error:,
    \%C\ \ \ \ \ %m,
    \%C%\\s%#,
    \%-G%.%#

let &cpoptions = s:cpo_save
unlet s:cpo_save
