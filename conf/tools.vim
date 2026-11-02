" conf/tools.vim -- C/C++ toolchain: built-ins first, dnf plugins second.
" Sourced by vimrc via `runtime! conf/*.vim`.  Leader is <Space>.
" Fedora vimfiles plugins load AFTER vimrc, so every plugin-dependent
" map is installed from VimEnter / FileType, where exists() is truthful.
" g:ale_* / g:gitgutter_* / g:ctrlp_* must be set before load: set unconditionally.

" ---- 1. ctags ---------------------------------------------------------------
set tags=./tags;,tags
set path+=**                          " :find / gf across the project
" <C-]> jump, <C-t> back, g<C-]> pick among matches, <C-w>} preview (builtin)

" ---- 2. cscope --------------------------------------------------------------
if has('cscope')
  if executable('cscope') | set cscopeprg=cscope | endif
  set cscopetag cscopetagorder=0 nocscopeverbose
  set cscopequickfix=s-,c-,d-,i-,t-,e-,a-
  function! s:CsAdd() abort
    let l:db = findfile('cscope.out', '.;')      " search upward like tags
    if !empty(l:db) && executable('cscope')
      let l:db = fnamemodify(l:db, ':p')
      silent! execute 'cscope add' fnameescape(l:db) fnameescape(fnamemodify(l:db, ':h'))
    endif
  endfunction
  call s:CsAdd()
  nnoremap <leader>cs :cscope find s <C-r><C-w><CR>
  nnoremap <leader>cg :cscope find g <C-r><C-w><CR>
  nnoremap <leader>cc :cscope find c <C-r><C-w><CR>
  nnoremap <leader>cd :cscope find d <C-r><C-w><CR>
  nnoremap <leader>ct :cscope find t <C-r><C-w><CR>
  nnoremap <leader>ce :cscope find e <C-r><C-w><CR>
  nnoremap <leader>cf :cscope find f <C-r><C-f><CR>
  nnoremap <leader>ci :cscope find i ^<C-r><C-f>$<CR>
  nnoremap <leader>cr :silent! cscope reset<CR>
endif

" ---- 3. make + quickfix, grep ----------------------------------------------
nnoremap <leader>mm :silent make!<bar>botright copen<bar>redraw!<CR>
nnoremap <leader>qo :botright copen<CR>
nnoremap <leader>qc :cclose<CR>
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
nnoremap <leader>gg :silent grep! ""<Left>
nnoremap <leader>* :silent grep! -w <C-r><C-w><CR>:botright copen<CR>:redraw!<CR>

" ---- 4. gdb via termdebug --------------------------------------------------
if has('terminal')
  " packadd must happen after startup, or :Termdebug fails with E117
  autocmd VimEnter * ++once silent! packadd termdebug
  let g:termdebug_config = {'wide': 163}   " source left, gdb right when wide enough
  nnoremap <leader>dd :Termdebug<space>
  nnoremap <leader>db :Break<CR>
  nnoremap <leader>dx :Clear<CR>
  nnoremap <leader>ds :Step<CR>
  nnoremap <leader>dn :Over<CR>
  nnoremap <leader>dc :Continue<CR>
  nnoremap <leader>df :Finish<CR>
  nnoremap <leader>de :Evaluate<CR>
endif

" ---- 5. netrw ---------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3
nnoremap <leader>e :Explore<CR>

" ---- 6. ALE (clangd only) ---------------------------------------------------
let g:ale_linters = {'c': ['clangd'], 'cpp': ['clangd']}
let g:ale_fixers = {}
let g:ale_fix_on_save = 0
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 0
let g:ale_c_clangd_options = '--background-index --clang-tidy=false'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_sign_error = 'E>'
let g:ale_sign_warning = 'W>'
" Optional extras, off by default (then also add them to g:ale_linters):
"   let g:ale_cpp_cppcheck_options = '--enable=warning,style'
"   let g:ale_linters.cpp = ['clangd', 'cppcheck', 'clangtidy']

function! s:AleBufferMaps() abort
  if !exists(':ALEInfo') | return | endif
  setlocal omnifunc=ale#completion#OmniFunc
  nnoremap <buffer> gd         :ALEGoToDefinition<CR>
  nnoremap <buffer> gr         :ALEFindReferences<CR>
  nnoremap <buffer> K          :ALEHover<CR>
  nnoremap <buffer> <leader>rn :ALERename<CR>
  nnoremap <buffer> <leader>ca :ALECodeAction<CR>
  nnoremap <buffer> ]d         :ALENextWrap<CR>
  nnoremap <buffer> [d         :ALEPreviousWrap<CR>
endfunction

" ---- 7. gitgutter / fugitive / CtrlP ---------------------------------------
let g:gitgutter_map_keys = 0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_use_caching = 0
if executable('rg')
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob "!.git" --glob "!tags"'
endif

function! s:PluginMaps() abort
  " vim-latex's imaps.vim takes a global <C-j> in every mode; give it back.
  " ftplugin/tex.vim restores the placeholder jump for insert mode in TeX buffers.
  nnoremap <C-j> <C-w>j
  silent! iunmap <C-j>
  silent! vunmap <C-j>
  if exists(':Git')
    nnoremap <leader>gs :Git<CR>
    nnoremap <leader>gb :Git blame<CR>
    nnoremap <leader>gd :Gdiffsplit<CR>
  endif
  if exists('g:loaded_gitgutter')
    nmap ]h <Plug>(GitGutterNextHunk)
    nmap [h <Plug>(GitGutterPrevHunk)
    nmap <leader>hs <Plug>(GitGutterStageHunk)
    nmap <leader>hu <Plug>(GitGutterUndoHunk)
    nmap <leader>hp <Plug>(GitGutterPreviewHunk)
  endif
  if exists(':CtrlP')
    nnoremap <leader>ff :CtrlP<CR>
    nnoremap <leader>bb :CtrlPBuffer<CR>
  else                                  " no plugin: builtin equivalents
    nnoremap <leader>ff :find<space>
    nnoremap <leader>bb :ls<CR>:buffer<space>
  endif
endfunction

augroup conf_tools
  autocmd!
  autocmd VimEnter * call s:PluginMaps()
  autocmd FileType c,cpp call s:AleBufferMaps()
augroup END
