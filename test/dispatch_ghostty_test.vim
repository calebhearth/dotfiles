" Regression test for the Ghostty vim-dispatch handler.
" Run from the repo root with `make test`, which does:
"   nvim --headless --clean -S test/dispatch_ghostty_test.vim

let s:root = expand('<sfile>:p:h:h')
set runtimepath^=~/.local/share/nvim/plugged/vim-dispatch
execute 'set runtimepath^=' . fnameescape(s:root . '/ghostty/.vim')
runtime plugin/dispatch.vim

let $GHOSTTY_RESOURCES_DIR = '/fake/ghostty'
let g:dispatch_fifo_callback = 0
let s:launched = tempname()
let g:dispatch_ghostty_launcher = 'cat %s > ' . shellescape(s:launched)

function! s:request(action, command) abort
  let file = dispatch#tempname()
  call writefile([], file)
  return {
        \ 'action': a:action,
        \ 'background': 0,
        \ 'command': a:command,
        \ 'expanded': a:command,
        \ 'directory': getcwd(),
        \ 'title': 'test',
        \ 'mods': '',
        \ 'id': 1,
        \ 'file': file,
        \ 'format': '%+I%.%#',
        \ }
endfunction

" Ghostty 1.3 quotes the New Terminal command as one shell word, so the
" shortcut must receive a single shlex-safe token: the path of a script.
let s:request = s:request('make', 'echo hello')
call assert_equal(1, dispatch#ghostty#handle(s:request))
let s:script = s:request.file . '.dispatch'
let s:input = filereadable(s:launched) ? readfile(s:launched) : []
call assert_equal([s:script], s:input)
call assert_match('^[A-Za-z0-9@%+=:,./_-]\+$', get(s:input, 0, ''))

call assert_true(filereadable(s:script), 'script written at ' . s:script)
if filereadable(s:script)
  call assert_equal('#!' . &shell, readfile(s:script)[0])
  call assert_match('^rwx', getfperm(s:script))

  call system(s:script . ' 2>/dev/null')
  call assert_true(getfsize(s:request.file . '.pid') > 0, 'pid file written')
  let s:complete = s:request.file . '.complete'
  call assert_equal(['0'], filereadable(s:complete) ? readfile(s:complete) : [])
  call assert_match('hello', join(readfile(s:request.file), "\n"))
endif

try
  call assert_equal(1, dispatch#ghostty#handle(s:request('start', 'true')))
catch
  call add(v:errors, 'start threw ' . v:exception)
endtry

let $GHOSTTY_RESOURCES_DIR = ''
call assert_equal(0, dispatch#ghostty#handle(s:request('make', 'echo hello')))

if empty(v:errors)
  quit
endif
for s:error in v:errors
  echomsg s:error
endfor
cquit!
