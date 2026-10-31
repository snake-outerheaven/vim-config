" conf/00-plugin-policy.vim -- make the config robust on any Debian box where
" `apt install vim*` pulled in every vim-* package.  Debian's pack/dist-bundle/start
" plugins load AFTER the vimrc, and a plugin skips itself if its guard variable
" is already set, so we pre-set the guards of the ones that clash with this setup.
" Guards verified against the Debian 13 (trixie) packages.
"
" Kept on purpose: vim-airline, ALE, fugitive, gitgutter, lastplace, gruvbox,
" solarized, language syntax packs.  youcompleteme and CtrlP live in opt/ and
" never auto-load.

let g:loaded_snips = 1                " snipmate: prints a deprecation prompt at startup
let g:loaded_syntastic_plugin = 1     " duplicates ALE linting
let g:AutoPairsLoaded = 1             " auto-pairs: changes typing behaviour
let g:loaded_minimap = 1
let g:command_t_loaded = 1            " competes with CtrlP
let g:loaded_pathogen = 1
let g:loaded_vimwiki = 1
let g:voom_did_load_plugin = 1
let g:loaded_redact_pass = 1
let g:loaded_link = 1
let g:plugin_migemo_disable = 1       " migemo: unused here (migemo.vim honours this)

" vim-airline: keep it plain, no powerline glyphs required.
let g:airline_powerline_fonts = 0
let g:airline_theme = 'dark'
let g:airline#extensions#tabline#enabled = 0
