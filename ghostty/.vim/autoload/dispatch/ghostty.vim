" https://github.com/SevereOverfl0w/.files/blob/3d7670366931a3428742890d0f63620e972743c7/dotfiles/.config/nvim/autoload/dispatch/ghostty.vim
if exists('g:autoloaded_dispatch_ghostty')
  finish
endif

let g:autoloaded_dispatch_ghostty = 1

function! dispatch#ghostty#handle(request) abort
  if a:request.action ==# 'make'
    " Using it for make is annoying (for now)
    " return 0
    let command = dispatch#prepare_make(a:request)
    let command = substitute(command, 'sync; perl', 'perl', '')
  elseif a:request.action ==# 'start'
    let command = command . dispatch#prepare_start(a:request)
  else
    return 0
  endif
  " Tell TTY to clear back super far (50 lines), go to col 0, clear to EOL
  " then print the command we want to see
  let command = 'printf ''\\e[50F\\r\\e[3J\\e[J' . a:request.expanded . '\n'' > /dev/tty; ' . command
  echo command

  if &shellredir =~# '%s'
    let redir = printf(&shellredir, '/dev/null')
  else
    let redir = &shellredir . ' ' . '/dev/null'
  endif

  let input = tempname()
  let output = tempname()
  if writefile([command . redir], input, "D") == -1
    echoerr 'Unable to write command to tempfile: '.command
    return -1
  endif

  let ghostty = 'shortcuts run "Run in Ghostty" --input-path='.shellescape(input).' --output-path='.shellescape(output)
  call system(ghostty)
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
