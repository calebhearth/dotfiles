let s:yaml = {}
function! rails#yaml_parse_file(file) abort
  if !has_key(s:yaml, a:file)
    let s:yaml[a:file] = [-2]
  endif
  let ftime = getftime(a:file)
  if ftime == s:yaml[a:file][0]
    return s:yaml[a:file][1]
  endif
  let json = system('ruby -rrails -e ' .
        \ s:rquote('puts Rails::Application::Configuration.new(ARGF.read).database_configuration.to_json')
        \ . ' ' . s:rquote(a:file))
  if !v:shell_error && json =~# '^[[{]'
    let s:yaml[a:file] = [ftime, rails#json_parse(json)]
    return s:yaml[a:file][1]
  endif
  throw 'invalid YAML file: '.a:file
endfunction
