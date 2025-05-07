if exists('g:autoloaded_mise_dispatch_test')
  finish
endif
let g:autoloaded_mise_dispatch_test = 1

if !exists('g:dispatch_compilers')
  let g:dispatch_compilers = {}
endif

" Avoid installing neovim in every project
if !exists('g:ruby_host_prog')
  let g:ruby_host_prog = '/Users/caleb/.gem/ruby/3.2.0/bin/neovim-ruby-host'
endif

let g:dispatch_compilers['mise exec --'] = ''
let g:dispatch_compilers['mise exec'] = ''

function! MiseTransform(cmd) abort
  if !empty(glob('.mise.*.toml')) || !empty(glob('mise.*.toml')) || !empty(glob('mise.toml')) || !empty(glob('.mise.toml'))
    return 'mise exec -- '.a:cmd
  else
    return a:cmd
  endif
endfunction

let g:test#custom_transformations = {'mise': function('MiseTransform')}
let g:test#transformation = 'mise'
