execute "source ".expand('<sfile>:h')."/../asyncrun.vim"

sign define EslintError text=E linehl=CocErrorLine texthl=CocErrorSign

function s:Eslint()
  AsyncRun npx --no-install --quiet eslint -f unix %
endfunction

function s:ClearHighlight()
  let bufnr = bufnr('%')
  for d in sign_getplaced('%')
    if d.bufnr == bufnr
      for s in d.signs
        if (s.name == "EslintError")
          call sign_unplace("", { 'buffer': bufnr, 'id': s.id })
        endif
      endfor
    endif
  endfor
endfunction

function s:Highlight()
  let bufnr = bufnr('%')
  for i in getqflist()
    if i.bufnr == bufnr && i.lnum > 0
      call sign_place(i.lnum, "", "EslintError", bufnr, { 'lnum': i.lnum })
    endif
  endfor
endfunction

function s:Diagnostics()
  let lnum = line('.')
  let bufnr = bufnr('%')
  for i in getqflist()
    if i.bufnr == bufnr && i.lnum == lnum
      echo "[eslint]" trim(i.text)
      return
    endif
  endfor
endfunction

augroup eslint
  autocmd!
  autocmd FileType typescript setlocal errorformat=%A%f:%l:%c:%m,%-G%.%#
  autocmd FileType javascript setlocal errorformat=%A%f:%l:%c:%m,%-G%.%#
  autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx call s:ClearHighlight()
  autocmd BufWritePost *.js,*.jsx call s:Eslint()
  autocmd BufWritePost *.ts,*.tsx call s:Eslint()
  autocmd QuickFixCmdPost * call s:Highlight()
  autocmd CursorHold * call s:Diagnostics()
augroup END
