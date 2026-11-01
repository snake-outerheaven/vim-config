" ~/.vim/vimrc -- plain vi-tradition setup for C/C++ systems work
" ---------------------------------------------------------------
" Works in terminal vim and gvim.  Tool maps live in conf/tools.vim.

" --- Basics ----------------------------------------------------
set nocompatible
set encoding=utf-8
scriptencoding utf-8
set fileencodings=ucs-bom,utf-8,default,latin1
set hidden                      " allow switching away from modified buffers
set backspace=indent,eol,start
set history=1000
set timeoutlen=800 ttimeoutlen=50
set nrformats-=octal
set autoread

let g:c_syntax_for_h = 1       " .h files are C, not C++ (override per project)
syntax on
filetype plugin indent on

" --- Search ----------------------------------------------------
set incsearch hlsearch
set ignorecase smartcase

" --- Display ---------------------------------------------------
set ruler showcmd wildmenu
set wildmode=longest:full,full
set wildoptions=pum                " completion menu as a popup list
set noshowmode                     " the status line shows the mode
set cursorline
set signcolumn=yes
set pumheight=12
set updatetime=250
set scrolloff=5 sidescrolloff=5
set number relativenumber
set laststatus=2
set display=lastline
set nowrap
set list
" Subtle whitespace markers: a faint chevron for tabs (kernel code is full of
" them), a dot for trailing spaces.  ASCII fallback when not in UTF-8.
if &encoding ==# 'utf-8'
  set listchars=tab:›\ ,trail:·,extends:›,precedes:‹,nbsp:␣
else
  set listchars=tab:>\ ,trail:~,extends:>,precedes:<,nbsp:+
endif
set diffopt+=internal,algorithm:patience

" Simple built-in statusline: file, flags, ft, encoding, position
set statusline=%<%f\ %h%m%r%=%y\ [%{&fileencoding!=''?&fileencoding:&encoding}]\ %l:%c\ %P

" colorcolumn for C/C++ is set in after/ftplugin/c.vim (81 = first column over
" the kernel's 80-column limit).

" --- Mouse / clipboard -----------------------------------------
set mouse=                      " no mouse in terminal; gvimrc sets mouse=a
if has('clipboard')
  set clipboard=unnamedplus
endif

" --- Indentation defaults (ftplugins override per language) ----
set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0
set autoindent

" --- Files: backup, swap, undo, viminfo ------------------------
let s:vimdir = expand('~/.vim')
for s:d in ['backup', 'swap', 'undo']
  if !isdirectory(s:vimdir . '/' . s:d)
    silent! call mkdir(s:vimdir . '/' . s:d, 'p', 0700)
  endif
endfor
let &backupdir = s:vimdir . '/backup//'
let &directory = s:vimdir . '/swap//'
let &undodir   = s:vimdir . '/undo//'
set backup writebackup undofile swapfile
let &viminfofile = s:vimdir . '/viminfo'
set viminfo='200,<500,s100,h,f1

" --- Colors ----------------------------------------------------
if has('termguicolors') && $COLORTERM =~# 'truecolor\|24bit'
  if !has('gui_running')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
endif
set background=dark
silent! colorscheme retrobox

" --- Generic maps ----------------------------------------------
let mapleader = "\<Space>"
let maplocalleader = ","
nnoremap <leader>w :update<CR>
nnoremap <leader>Q :q<CR>
nnoremap <leader><CR> :nohlsearch<CR>
" buffers
nnoremap <leader>bl :ls<CR>:buffer<Space>
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader><Tab> <C-^>
" quickfix
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]Q :clast<CR>
nnoremap [Q :cfirst<CR>
" location list
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lc :lclose<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>
" windows / misc
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap Y y$

" Jump to last known cursor position
augroup vimrc_lastpos
  autocmd!
  autocmd BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$")
        \ && &ft !~# 'commit' | exe "normal! g`\"" | endif
augroup END

" --- Per-tool configuration (conf/tools.vim etc.) --------------
runtime! conf/*.vim

" --- Machine-specific overrides (gitignored) --------------------
if filereadable(expand("~/.vim/local.vim"))
  source ~/.vim/local.vim
endif

" --- Plugins and colorscheme, last -------------------------------
" Debian's pack/dist-bundle/start plugins normally load after the vimrc, which is
" too late for :colorscheme to find vim-gruvbox.  :packloadall loads them here instead,
" after conf/*.vim and local.vim have set the guard variables and options.
if has('packages')
  packloadall
endif
silent! colorscheme gruvbox         " falls back to the retrobox set above
