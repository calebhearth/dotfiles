if exists("b:current_syntax")
  finish
endif

syntax include @cpp syntax/cpp.vim

syntax match logfmtKey /\<\zs[A-Za-z_]\w*\ze=/
syntax match logfmtEquals /=/
syntax match logfmtTimestamp /\v<(t|time|timestamp|created|updated)=\zs[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\.[0-9]+)?Z/ containedin=ALL

syntax region logfmtFunctionValue matchgroup=logfmtEquals start=+function="+lc=10 end=+"+he=e-1 contains=@cpp oneline containedin=ALL keepend
syntax region logfmtQuotedValue matchgroup=logfmtEquals start=/=\s*"/ skip=/\\"/ end=/"/ oneline
syntax match logfmtValue /=\zs\%(INFO\|DEBUG\|WARN\|ERROR\|TRACE\|FATAL\)\@![^"'\s][^,\s]*/

syntax match logfmtLevelTrace "TRACE"  containedin=ALL
syntax match logfmtLevelDebug "DEBUG" containedin=ALL
syntax match logfmtLevelInfo  "INFO"  containedin=ALL
syntax match logfmtLevelWarn  "WARN"   containedin=ALL
syntax match logfmtLevelError "ERROR"  containedin=ALL
syntax match logfmtLevelFatal "FATAL"  containedin=ALL

highlight default link logfmtKey Identifier
highlight default link logfmtEquals Operator
highlight default link logfmtTimestamp Number
highlight default link logfmtValue String
highlight default link logfmtQuotedValue String

highlight default link logfmtLevelTrace Comment
highlight default link logfmtLevelDebug Normal
highlight default link logfmtLevelInfo Identifier
highlight default link logfmtLevelWarn WarningMsg
highlight default link logfmtLevelError Error
highlight default link logfmtLevelFatal Error

let b:current_syntax = "logfmt"
