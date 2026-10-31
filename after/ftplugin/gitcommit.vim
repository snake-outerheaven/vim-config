" Commit messages: subject <=50, body wrapped at 72, spell on.
setlocal textwidth=72 colorcolumn=51,73 spell
let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . '|' : '')
      \ . 'setlocal tw< cc< spell<'
