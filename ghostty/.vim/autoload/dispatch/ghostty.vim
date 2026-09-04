" https://github.com/SevereOverfl0w/.files/blob/3d7670366931a3428742890d0f63620e972743c7/dotfiles/.config/nvim/autoload/dispatch/ghostty.vim
"
" The "Run in Ghostty" shortcut hands the input file's contents to Ghostty's New
" Terminal intent, which quotes them as one shell word (Ghostty 1.3). So the
" file holds a single token: the path of the script that runs the request.
if exists('g:autoloaded_dispatch_ghostty')
  finish
endif

let g:autoloaded_dispatch_ghostty = 1

let g:dispatch_ghostty_launcher = get(g:, 'dispatch_ghostty_launcher',
      \ 'shortcuts run "Run in Ghostty" --input-path=%s')

function! dispatch#ghostty#handle(request) abort
  if empty($GHOSTTY_RESOURCES_DIR)
    return 0
  endif
  if a:request.action ==# 'make'
    let command = dispatch#prepare_make(a:request)
  elseif a:request.action ==# 'start'
    let command = dispatch#prepare_start(a:request)
  else
    return 0
  endif
  let command = substitute(command, 'sync; perl', 'perl', '')

  let script = a:request.file . '.dispatch'
  call writefile([
        \ '#!' . &shell,
        \ 'cd ' . dispatch#shellescape(a:request.directory),
        \ 'printf ''\e[50F\r\e[3J\e[J%s\n'' ' . dispatch#shellescape(a:request.expanded) . ' > /dev/tty',
        \ command,
        \ ], script)
  call setfperm(script, 'rwx------')

  let input = tempname()
  call writefile([script], input, 'D')
  call system(printf(g:dispatch_ghostty_launcher, shellescape(input)))
  return !v:shell_error
endfunction

" function! dispatch#ghostty#activate(pid) abort
"   let out = system('ps ewww -p '.a:pid)
"   let listen_on = matchstr(out, 'ghostty_LISTEN_ON=\zs\S\+')
"   let call = 'ghostty @ '
"   if !empty(listen_on)
"     let call .= '--to '. listen_on . ' '
"   endif
"   let call .= 'focus-window --match pid:'. a:pid
"   call system(call)
"   return !v:shell_error
" endfunction
