" ~/.vim/gvimrc -- GUI-only settings (Fedora: vim-X11)

set guifont=Cascadia\ Code\ 11
set guioptions=ac               " no menu, toolbar, scrollbars, tearoffs
set mouse=a
set mousemodel=popup_setpos
set belloff=all
set guicursor=n-v-c:block-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,a:blinkon0
set lines=45 columns=130
set shortmess+=I                " no intro splash

" Simple background handling: dark by default; :Light / :Dark to switch.
" retrobox first, so it remains when gruvbox isn't installed.
function! s:Theme(background) abort
  let &background = a:background
  silent! colorscheme retrobox
  silent! colorscheme gruvbox
endfunction
command! Light call s:Theme('light')
command! Dark  call s:Theme('dark')
