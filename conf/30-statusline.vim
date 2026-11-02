" conf/30-statusline.vim -- status line and buffer tabline in plain Vim script.
" Fedora has no vim-airline package.  Git and ALE segments appear when those
" plugins are loaded; colors are gruvbox's, so they also work over retrobox.

function! s:Colors() abort
  for [l:group, l:gui, l:cterm] in [
        \ ['StlNormal',  '#fabd2f', 214],
        \ ['StlInsert',  '#83a598', 109],
        \ ['StlVisual',  '#fe8019', 208],
        \ ['StlReplace', '#fb4934', 167],
        \ ['StlCommand', '#b8bb26', 142],
        \ ['StlTerminal', '#8ec07c', 108]]
    execute printf('highlight %s guifg=#1d2021 guibg=%s ctermfg=234 ctermbg=%d gui=bold cterm=bold',
          \ l:group, l:gui, l:cterm)
  endfor
  highlight StlSection guifg=#ebdbb2 guibg=#504945 ctermfg=223 ctermbg=239 gui=NONE cterm=NONE
  highlight StlFile    guifg=#ebdbb2 guibg=#3c3836 ctermfg=223 ctermbg=237 gui=NONE cterm=NONE
  highlight StlError   guifg=#fb4934 guibg=#3c3836 ctermfg=167 ctermbg=237 gui=bold cterm=bold
  highlight StlWarning guifg=#fabd2f guibg=#3c3836 ctermfg=214 ctermbg=237 gui=bold cterm=bold
  highlight StlInactive guifg=#928374 guibg=#3c3836 ctermfg=245 ctermbg=237 gui=NONE cterm=NONE
  highlight StatusLine   guifg=#ebdbb2 guibg=#3c3836 ctermfg=223 ctermbg=237 gui=NONE cterm=NONE
  highlight StatusLineNC guifg=#928374 guibg=#3c3836 ctermfg=245 ctermbg=237 gui=NONE cterm=NONE
  highlight TabLine     guifg=#a89984 guibg=#3c3836 ctermfg=246 ctermbg=237 gui=NONE cterm=NONE
  highlight TabLineSel  guifg=#1d2021 guibg=#fabd2f ctermfg=234 ctermbg=214 gui=bold cterm=bold
  highlight TabLineFill guifg=#a89984 guibg=#1d2021 ctermfg=246 ctermbg=234 gui=NONE cterm=NONE
endfunction

let s:modes = {
      \ 'n': ['NORMAL', 'StlNormal'],
      \ 'i': ['INSERT', 'StlInsert'],
      \ 'R': ['REPLACE', 'StlReplace'],
      \ 'v': ['VISUAL', 'StlVisual'],
      \ 'V': ['V-LINE', 'StlVisual'],
      \ "\<C-v>": ['V-BLOCK', 'StlVisual'],
      \ 's': ['SELECT', 'StlVisual'],
      \ 'S': ['S-LINE', 'StlVisual'],
      \ "\<C-s>": ['S-BLOCK', 'StlVisual'],
      \ 'c': ['COMMAND', 'StlCommand'],
      \ 't': ['TERMINAL', 'StlTerminal']}

function! s:Git() abort
  let l:out = ''
  if exists('*FugitiveHead')
    let l:head = FugitiveHead()
    if l:head !=# ''
      let l:out = ' git:' . l:head
    endif
  endif
  if l:out !=# '' && exists('*GitGutterGetHunkSummary')
    let [l:add, l:mod, l:del] = GitGutterGetHunkSummary()
    if l:add + l:mod + l:del > 0
      let l:out .= printf(' +%d ~%d -%d', l:add, l:mod, l:del)
    endif
  endif
  return empty(l:out) ? '' : l:out . ' '
endfunction

function! s:Ale() abort
  if !exists('g:loaded_ale') | return '' | endif
  let l:c = ale#statusline#Count(bufnr(''))
  let l:errors = l:c.error + l:c.style_error
  let l:warnings = l:c.total - l:errors
  return (l:errors ? '%#StlError# E:' . l:errors . ' ' : '')
        \ . (l:warnings ? '%#StlWarning# W:' . l:warnings . ' ' : '')
endfunction

" %! runs in the current window; g:statusline_winid is the one being drawn.
function! StatuslineRender() abort
  let l:file = ' %<%f %h%m%r'
  if g:statusline_winid != win_getid()
    return '%#StlInactive#' . l:file . '%=%l:%c '
  endif
  let l:mode = get(s:modes, mode()[0], s:modes.n)
  let l:git = substitute(s:Git(), '%', '%%', 'g')
  return '%#' . l:mode[1] . '# ' . l:mode[0] . ' '
        \ . '%#StlSection#' . l:git
        \ . '%#StlFile#' . l:file . '%=' . s:Ale()
        \ . '%#StlFile# %y %{&fileencoding!=#""?&fileencoding:&encoding} '
        \ . '%#' . l:mode[1] . '# %p%% %l:%c '
endfunction

" Listed buffers; the same file name in two directories gets its parent's name.
function! TablineRender() abort
  let l:bufs = getbufinfo({'buflisted': 1})
  let l:count = {}
  for l:b in l:bufs
    let l:tail = fnamemodify(l:b.name, ':t')
    let l:count[l:tail] = get(l:count, l:tail, 0) + 1
  endfor
  let l:out = ''
  for l:b in l:bufs
    let l:tail = fnamemodify(l:b.name, ':t')
    let l:label = l:tail ==# '' ? '[No Name]'
          \ : l:count[l:tail] > 1 ? fnamemodify(l:b.name, ':h:t') . '/' . l:tail : l:tail
    let l:out .= (l:b.bufnr == bufnr('') ? '%#TabLineSel#' : '%#TabLine#')
          \ . ' ' . substitute(l:label, '%', '%%', 'g') . (l:b.changed ? ' +' : '') . ' '
  endfor
  let l:out .= '%#TabLineFill#%='
  if tabpagenr('$') > 1
    let l:out .= '%#TabLine# tab ' . tabpagenr() . '/' . tabpagenr('$') . ' '
  endif
  return l:out
endfunction

call s:Colors()
set statusline=%!StatuslineRender()
set tabline=%!TablineRender()
set showtabline=2

augroup statusline_colors
  autocmd!
  autocmd ColorScheme * call s:Colors()
  autocmd ModeChanged * redrawstatus
augroup END
