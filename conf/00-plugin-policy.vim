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

" vim-airline (Debian: vim-airline + vim-airline-themes) with the gruvbox airline theme
" that ships inside vim-gruvbox.  Plain symbols by default; with a Powerline/Nerd Font put
" `let g:airline_powerline_fonts = 1` in ~/.vim/local.vim.
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 0
let g:airline_symbols = {'branch': 'git:'}    " ASCII; Powerline fonts replace it automatically
let g:airline_skip_empty_sections = 1
let g:airline_section_z = '%p%%  %l:%c'
let g:airline_exclude_filetypes = add(get(g:, 'airline_exclude_filetypes', []), 'start')
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#whitespace#enabled = 0   " the C ftplugin already marks whitespace

" gruvbox colorscheme (Debian: vim-gruvbox); applied at the end of the vimrc.
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 1
let g:gruvbox_bold = 1
let g:gruvbox_invert_selection = 0
