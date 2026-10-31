" Makefiles require real tabs.
setlocal noexpandtab tabstop=8 shiftwidth=8 softtabstop=0 nosmarttab
setlocal textwidth=0 colorcolumn=
let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . '|' : '')
      \ . 'setlocal et< ts< sw< sts< sta< tw< cc<'
