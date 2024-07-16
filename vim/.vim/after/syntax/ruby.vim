" syntax on
" " syntax include @SQL syntax/pgsql.vim
" " syntax include @JS syntax/javascript.vim
" syntax region rubyHeredocSql
"       \ matchgroup=Statement
"       \ start=+<<-\?\(['"]\?\)\z(\s*SQL\s*\)\1+
"       \ end=+^\s*\z1$+
"       \ contains=sql
" syntax region rubyHeredocJavascript
"       \ matchgroup=Statement
"       \ start=+<<-\?\(['"]\?\)\z(\s*JS\s*\)\1+
"       \ end=+^\s*\z1$+
"       \ contains=javascript
" let s:bcs = b:current_syntax
" unlet b:current_syntax
" syntax include @SQL syntax/sql.vim
" syntax include @JS syntax/javascript.vim
" let b:current_syntax = s:bcs
" syntax region rubyHereDocSQL
"       \ matchgroup=Statement
"       \ start=+<<\(['"]\?\)\z(SQL\)\1+
"       \ end=+^\z1$+
"       \ contains=@SQL
" syntax region rubyHereDocDashSQL
"       \ matchgroup=Statement
"       \ start=+<<-\(['"]\?\)\z(SQL\)\1+
"       \ end=+\s*\+\z1$+
"       \ contains=@SQL
" syntax region rubyHeredocJS
"       \ matchgroup=String
"       \ start=+<<\(['"]\?\)\z(JS\)\1+
"       \ end=+^\z1$+
"       \ contains=@JS
" syntax region rubyHereDocDashJS
"       \ matchgroup=String
"       \ start=+<<-\(['"]\?\)\z(JS\)\1+
"       \ end=+\s*\z1$+
"       \ contains=@JS
