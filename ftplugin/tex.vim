" TeX buffers: runs before Fedora's vim-latex ftplugin.

" bibtools.py line 47 has an invalid escape sequence that Python 3.14 reports as
" a SyntaxWarning on every .tex file.
if has('python3')
  py3 import warnings; warnings.filterwarnings('ignore', category=SyntaxWarning)
endif

" Placeholder jump, removed globally in conf/tools.vim.
imap <buffer> <C-j> <Plug>IMAP_JumpForward

let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . '|' : '')
      \ . 'silent! iunmap <buffer> <C-j>'
