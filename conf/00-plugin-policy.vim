" conf/00-plugin-policy.vim -- make the config robust on a Fedora box where
" `dnf install 'vim-*'` pulled in every plugin package.  Fedora's plugins live
" directly in /usr/share/vim/vimfiles/plugin and load AFTER the vimrc, and a
" plugin skips itself if its guard variable is already set, so we pre-set the
" guards of the ones that clash with this setup.  Each new plugin that appears
" there makes bin/check-fedora.sh fail until it has been reviewed.
" Guards verified against the Fedora 44 packages.
"
" Kept on purpose: ALE, fugitive, rhubarb, gitgutter, commentary, CtrlP, taglist,
" CCTree, vim-go, perl-support and the language syntax packs.

let g:powerline_loaded = 1                  " needs syntastic state; own status line in conf/30
let g:loaded_syntastic_plugin = 1           " duplicates ALE linting
let g:command_t_loaded = 1                  " competes with CtrlP
let g:loaded_javabroswer = 1                " sic: the plugin's own spelling
let g:loaded_trailing_whitespace_plugin = 1 " the C ftplugin already marks whitespace

" Plugin options that only have an effect before the plugin loads.
let g:go_gopls_enabled = executable('gopls') " otherwise vim-go warns on every .go file
let g:jedi#auto_vim_configuration = 0        " leave completeopt and friends alone
let g:NERDTreeHijackNetrw = 0                " `vim .` and :Explore stay netrw
let g:Perl_Ctrl_j = 'off'                    " keep <C-j> as window-down in Perl buffers

" gruvbox colorscheme (Fedora: awesome-vim-colorschemes); applied at the end of the vimrc.
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 1
let g:gruvbox_bold = 1
let g:gruvbox_invert_selection = 0
