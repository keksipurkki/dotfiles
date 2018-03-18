if exists('loaded_column') || &cp
  finish
endif

let loaded_column = 1

" Takes a separator pattern and pretty-prints an aligned table
"
" Depends on column(1), part of the util-linux package
function! s:Tabulate(args) range

  let l:args = split(a:args, '-o')

  if (len(l:args) > 2 || len(l:args) == 0)
    throw "E474"
  endif

  let l:separator = substitute(l:args[0], '^\s*\(.\{-}\)\s*$', '\1', '')
  let l:output_separator = (len(l:args) > 0 ? '--output-separator '.l:args[1] : '')
  let l:decorator = "\uFFFE" " 

  silent exe a:firstline.','.a:lastline.'substitute/\('.l:separator.'\)/'.l:decorator.'/g'
  let l:cmd = a:firstline.','.a:lastline.'!column '
        \ .'--table '
        \ .'--separator '.l:decorator.' ' 
        \ .l:output_separator
  silent exe l:cmd
endfunction

command! -range=% -nargs=+ Tabulate <line1>,<line2>:call <SID>Tabulate("<args>")
