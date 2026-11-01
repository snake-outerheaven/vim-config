" conf/20-start.vim -- Gruvbox start screen, shown when Vim is opened without a file.
" Debian has no vim-startify package, so this is a small plain-Vim version:
" logo with a yellow-to-red gradient, one-key buttons, recent files, version footer.
" Reopen it any time with :Start.

if exists('g:loaded_start_screen') || !has('patch-8.2.0000')
  finish
endif
let g:loaded_start_screen = 1

let s:logo = [
      \ '██╗   ██╗██╗███╗   ███╗',
      \ '██║   ██║██║████╗ ████║',
      \ '██║   ██║██║██╔████╔██║',
      \ '╚██╗ ██╔╝██║██║╚██╔╝██║',
      \ ' ╚████╔╝ ██║██║ ╚═╝ ██║',
      \ '  ╚═══╝  ╚═╝╚═╝     ╚═╝']

" key, label, command.  "<CtrlP>" and "<grep>" are resolved when the key is pressed.
let s:buttons = [
      \ ['f', 'Find file',     'call feedkeys(exists(":CtrlP") ? ":CtrlP\<CR>" : ":find ", "n")'],
      \ ['g', 'Grep text',     'call feedkeys(":silent grep! ", "n")'],
      \ ['r', 'Recent files',  'browse oldfiles'],
      \ ['e', 'Explore',       'Explore'],
      \ ['n', 'New file',      'enew'],
      \ ['c', 'Configuration', 'edit $MYVIMRC'],
      \ ['q', 'Quit',          'qall']]

let s:commands = {}     " key -> command, rebuilt on every render
let s:lines = {}        " line number -> key

function! s:Colors() abort
  let l:gui = ['#fabd2f', '#f9a82e', '#fa8f31', '#fb7732', '#fb6033', '#fb4934']
  let l:cterm = [220, 214, 208, 208, 202, 167]
  for l:i in range(len(l:gui))
    execute printf('highlight StartHeader%d guifg=%s ctermfg=%d gui=bold cterm=bold',
          \ l:i + 1, l:gui[l:i], l:cterm[l:i])
  endfor
  highlight StartKey    guifg=#b8bb26 ctermfg=142 gui=bold cterm=bold
  highlight StartPath   guifg=#928374 ctermfg=245
  highlight StartFooter guifg=#928374 ctermfg=245 gui=italic cterm=italic
endfunction

function! s:Recent(n) abort
  let l:out = []
  for l:f in v:oldfiles
    if len(l:out) >= a:n | break | endif
    let l:p = fnamemodify(l:f, ':p')
    if filereadable(l:p) && l:p !~# '/\.git/\|^/tmp/\|COMMIT_EDITMSG\|/doc/.*\.txt$'
      call add(l:out, l:p)
    endif
  endfor
  return l:out
endfunction

function! s:Short(path, max) abort
  let l:p = fnamemodify(a:path, ':~:.')
  if strchars(l:p) > a:max
    let l:p = '…' . strcharpart(l:p, strchars(l:p) - a:max + 1)
  endif
  return l:p
endfunction

function! s:Render() abort
  setlocal modifiable
  silent keepjumps %delete _
  call clearmatches()
  let s:commands = {}
  let s:lines = {}

  let l:w = winwidth(0)
  let l:text = []      " lines of text
  let l:marks = []     " [line, group, col, len]  (col 0 = whole line)
  let l:keys = []      " [line, key]

  " logo
  for l:i in range(len(s:logo))
    let l:pad = repeat(' ', max([0, (l:w - strdisplaywidth(s:logo[l:i])) / 2]))
    call add(l:text, l:pad . s:logo[l:i])
    call add(l:marks, [len(l:text), 'StartHeader' . (l:i + 1), 0, 0])
  endfor
  call add(l:text, '')
  call add(l:text, '')

  " block width = widest button or recent entry
  let l:recent = s:Recent(5)
  let l:bw = 0
  for l:b in s:buttons
    let l:bw = max([l:bw, strdisplaywidth(l:b[1])])
  endfor
  let l:rec_labels = map(copy(l:recent), 's:Short(v:val, 46)')
  for l:r in l:rec_labels
    let l:bw = max([l:bw, strdisplaywidth(l:r)])
  endfor
  let l:pad = repeat(' ', max([0, (l:w - (l:bw + 6)) / 2]))

  for l:b in s:buttons
    call add(l:text, l:pad . '[' . l:b[0] . ']  ' . l:b[1])
    call add(l:marks, [len(l:text), 'StartKey', len(l:pad) + 2, 1])
    call add(l:keys, [len(l:text), l:b[0]])
    let s:commands[l:b[0]] = l:b[2]
  endfor

  if !empty(l:recent)
    call add(l:text, '')
    call add(l:text, l:pad . 'Recent files')
    call add(l:marks, [len(l:text), 'StartFooter', len(l:pad) + 1, 12])
    for l:i in range(len(l:recent))
      let l:k = string(l:i + 1)
      call add(l:text, l:pad . '[' . l:k . ']  ' . l:rec_labels[l:i])
      call add(l:marks, [len(l:text), 'StartKey', len(l:pad) + 2, 1])
      call add(l:marks, [len(l:text), 'StartPath', len(l:pad) + 6, 1000])
      call add(l:keys, [len(l:text), l:k])
      let s:commands[l:k] = 'edit ' . fnameescape(l:recent[l:i])
    endfor
  endif

  " footer
  let l:foot = printf('Vim %d.%d  ·  %s', v:version / 100, v:version % 100, fnamemodify(getcwd(), ':~'))
  call add(l:text, '')
  call add(l:text, repeat(' ', max([0, (l:w - strdisplaywidth(l:foot)) / 2])) . l:foot)
  call add(l:marks, [len(l:text), 'StartFooter', 0, 0])

  " vertical centering
  let l:top = max([1, (winheight(0) - len(l:text)) / 4])
  call setline(1, repeat([''], l:top) + l:text)
  for l:m in l:marks
    let l:ln = l:m[0] + l:top
    call matchaddpos(l:m[1], [l:m[2] == 0 ? l:ln : [l:ln, l:m[2], l:m[3]]])
  endfor
  for l:k in l:keys
    let s:lines[l:k[0] + l:top] = l:k[1]
  endfor
  setlocal nomodifiable nomodified

  " cursor on the first button
  call cursor(l:keys[0][0] + l:top, 1)
endfunction

function! s:Run(key) abort
  if !has_key(s:commands, a:key) | return | endif
  execute s:commands[a:key]
endfunction

function! s:RunLine() abort
  let l:k = get(s:lines, line('.'), '')
  if l:k !=# '' | call s:Run(l:k) | endif
endfunction

function! s:Open() abort
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted filetype=start
  setlocal nonumber norelativenumber nolist nowrap nospell
  setlocal signcolumn=no colorcolumn= foldcolumn=0 cursorline statusline=%#Normal#
  call s:Render()
  nnoremap <buffer> <silent> <CR> :call <SID>RunLine()<CR>
  for l:b in s:buttons
    execute 'nnoremap <buffer> <silent> ' . l:b[0] . ' :call <SID>Run(' . string(l:b[0]) . ')<CR>'
  endfor
  for l:i in range(1, 5)
    execute 'nnoremap <buffer> <silent> ' . l:i . ' :call <SID>Run(' . string(string(l:i)) . ')<CR>'
  endfor
  " no tabline here, and give the window its normal options back when the start screen is left
  let s:showtabline = &showtabline
  set showtabline=0
  autocmd BufLeave <buffer> call s:Leave()
endfunction

function! s:Leave() abort
  setlocal number< relativenumber< list< wrap< spell< signcolumn< colorcolumn< foldcolumn<
        \ cursorline< statusline<
  let &showtabline = s:showtabline
endfunction

function! s:Maybe() abort
  if argc() != 0 || exists('s:std_in') || &insertmode || &modified
        \ || bufname('%') !=# '' || line2byte('$') != -1
    return
  endif
  call s:Open()
endfunction

call s:Colors()
command! Start enew | call <SID>Open()

augroup start_screen
  autocmd!
  autocmd ColorScheme * call s:Colors()
  autocmd StdinReadPre * let s:std_in = 1
  autocmd VimEnter * nested call s:Maybe()
  autocmd VimResized * if &filetype ==# 'start' | call s:Render() | endif
augroup END
