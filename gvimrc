" ~/.vim/gvimrc -- GUI-only settings (vim-gtk3)

set guifont=Cascadia\ Code\ 11
set guioptions=ac               " no menu, toolbar, scrollbars, tearoffs
set mouse=a
set mousemodel=popup_setpos
set belloff=all
set guicursor=n-v-c:block-Cursor,i-ci:ver25-Cursor,r-cr:hor20-Cursor,a:blinkon0
set lines=45 columns=130
set shortmess+=I                " no intro splash

" Simple background handling: dark by default; :Light / :Dark to switch
set background=dark
silent! colorscheme retrobox
command! Light set background=light | silent! colorscheme retrobox
command! Dark  set background=dark  | silent! colorscheme retrobox
