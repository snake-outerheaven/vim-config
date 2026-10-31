" Linux kernel coding style for C (Documentation/process/coding-style.rst).
" Buffer-local only, no autocmds; everything reversible via b:undo_ftplugin.

setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=0 nosmarttab
setlocal textwidth=80 colorcolumn=81
setlocal cindent
" :0 case at switch indent, l1 align with case label, t0 fn return type,
" g0 scope decls at 0, (0 / u0 / w1 aligned args, +8 via sw for continuation
setlocal cinoptions=:0,l1,t0,g0,(0,u0,w1,Ws
setlocal cinkeys=0{,0},0),0],:,0#,!^F,o,O,e
setlocal comments=sO:\ *\ -,mO:\ *\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
setlocal formatoptions=croqlj
setlocal makeprg=make
silent! compiler gcc

" Highlight trailing whitespace and space-before-tab (window-local matches).
function! KernelWS() abort
  if exists('w:kernel_ws') | return | endif
  let w:kernel_ws = [matchadd('Error', '\s\+$', 10),
        \ matchadd('Error', ' \+\ze\t', 10)]
endfunction
function! KernelWSOff() abort
  if exists('w:kernel_ws')
    for l:id in w:kernel_ws
      if l:id > 0 | silent! call matchdelete(l:id) | endif
    endfor
    unlet w:kernel_ws
  endif
endfunction
call KernelWS()
augroup kernel_ws
  autocmd! * <buffer>
  autocmd BufWinEnter <buffer> call KernelWS()
  autocmd BufWinLeave <buffer> call KernelWSOff()
augroup END

" Format whole buffer (or visual range) through clang-format, keep cursor.
if !exists('*KernelClangFormat')
  function! KernelClangFormat(...) range abort
    if !executable('clang-format')
      echohl WarningMsg | echo 'clang-format not found' | echohl None
      return
    endif
    let l:view = winsaveview()
    let l:first = a:0 ? a:1 : 1
    let l:last = a:0 ? a:2 : line('$')
    " Use the full path so .clang-format is found upward from the file; fall
    " back to ~/.clang-format for files outside $HOME (e.g. /usr/src).
    let l:name = expand('%:p') ==# '' ? 'x.c' : expand('%:p')
    let l:style = (empty(findfile('.clang-format', expand('%:p:h') . ';'))
          \ && empty(findfile('_clang-format', expand('%:p:h') . ';'))
          \ && filereadable(expand('~/.clang-format')))
          \ ? '--style=file:' . shellescape(expand('~/.clang-format')) : '--style=file'
    let l:out = system('clang-format ' . l:style . ' --assume-filename='
          \ . shellescape(l:name)
          \ . ' --lines=' . l:first . ':' . l:last,
          \ join(getline(1, '$'), "\n") . "\n")
    if v:shell_error
      echohl ErrorMsg | echo 'clang-format failed' | echohl None
    else
      let l:new = split(l:out, "\n", 1)
      if l:new[-1] ==# '' | call remove(l:new, -1) | endif
      if l:new !=# getline(1, '$')
        silent keepjumps call setline(1, l:new)
        if line('$') > len(l:new)
          silent keepjumps execute len(l:new) + 1 . ',$delete _'
        endif
      endif
    endif
    call winrestview(l:view)
  endfunction
endif
nnoremap <buffer> <silent> <leader>= :call KernelClangFormat()<CR>
xnoremap <buffer> <silent> <leader>= :<C-u>call KernelClangFormat(line("'<"), line("'>"))<CR>

let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . '|' : '')
      \ . 'setlocal et< ts< sw< sts< sta< tw< cc< cin< cino< cink< com< fo< mp<'
      \ . '|call KernelWSOff()'
      \ . '|exe "silent! nunmap <buffer> <leader>="|exe "silent! xunmap <buffer> <leader>="'
