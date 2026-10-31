" C++: deliberate variation. Inherits the kernel C settings (Vim sources
" ftplugin/c.vim, hence after/ftplugin/c.vim, for cpp) so kernel-style C++ and
" mixed C/C++ trees stay consistent: tabs of 8, 80 columns.
" Differences: namespaces are not indented (N-s), lambdas/braces j1,J1.
" Edit here if a project uses 2/4-space C++.
setlocal cinoptions+=N-s,j1,J1
let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . '|' : '')
      \ . 'setlocal cino<'
