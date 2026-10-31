# vim-config

Plain, vi-tradition Vim setup for Unix C/C++ systems programming in the Linux
kernel coding style (8-wide tabs, 80 columns, `clang-format` with the kernel
style).  Built for Debian 13 (Vim 9.1) using only packages from the Debian
repositories: no plugin manager, no downloads.  Works in terminal Vim and gvim.

This repository used to hold an Emacs configuration; it is still in the git
history before the switch to Vim.

License: [MIT](LICENSE).

## Layout

```
vimrc                      core settings, Space leader, built-in colorscheme
gvimrc                     gvim only: Cascadia Code 11, no toolbar/menu
conf/00-plugin-policy.vim  neutralise Debian plugins that clash with this setup
conf/tools.vim             ctags, cscope, :make/quickfix, termdebug, ALE, git, CtrlP
after/ftplugin/            kernel style for C and C++, Makefile, git commits
bin/mkproject.sh           compile_commands.json + tags + cscope for a project
templates/                 Makefile.skel, .editorconfig
home/                      files to copy into $HOME (.clang-format, clangd config)
```

Runtime state (`backup/`, `swap/`, `undo/`, `viminfo`) is created on first run
and gitignored.  Put machine-specific overrides in `local.vim` (also ignored).

## Setup (Debian 13)

```sh
git clone <this repo> ~/.vim
sudo apt install vim* clang-format clang-tidy clangd bear universal-ctags cscope ripgrep cppcheck valgrind
cp ~/.vim/home/.clang-format ~/
mkdir -p ~/.config/clangd && cp ~/.vim/home/.config/clangd/config.yaml ~/.config/clangd/
```

A `~/.vimrc` takes precedence over `~/.vim/vimrc`, so remove or rename it.

`vim*` installs every Debian Vim plugin.  `conf/00-plugin-policy.vim` makes that
safe: it pre-sets the guard variable of each auto-loading plugin that clashes
with this setup (snipmate, syntastic, auto-pairs, minimap, command-t, pathogen,
vimwiki, voom, ...), so they never load.  Kept: airline (plain theme, no
powerline fonts), ALE, fugitive, gitgutter, lastplace.  CtrlP is loaded
explicitly with `packadd`; youcompleteme is in `opt/` and never auto-loads.

## Generic maps

Leader is Space.  `<leader>w` write, `<leader>Q` quit, `<leader><CR>` clear
search highlight, `<leader>bl` list buffers, `<leader>bd` delete buffer,
`<leader>n`/`p` next/prev buffer, `<leader><Tab>` alternate, `<leader>lo`/`lc`
location list, `]l [l`, `]Q [Q`, `<C-h/j/k/l>` windows, `Y` = `y$`.
`<leader>=` (C/C++) formats the buffer or selection with clang-format.

## Per-project setup
    bin/mkproject.sh [dir]   # compile_commands.json (cmake or `bear -- make -B`),
                             # tags (universal-ctags), cscope.out (-bqk from cscope.files)
Build with `-g` for gdb. clangd (via ALE) reads compile_commands.json.

## Tags / cscope (built-in)
`<C-]>` jump, `<C-t>` back, `g<C-]>` choose among matches, `<C-w>}` preview.
cscope.out is found upward from cwd; `cscopetag` makes `<C-]>` use cscope too.
| key | :cscope find |
|---|---|
| `<leader>cs` symbol | `<leader>cg` definition |
| `<leader>cc` callers | `<leader>cd` callees |
| `<leader>ct` text | `<leader>ce` egrep |
| `<leader>cf` file | `<leader>ci` includers |
| `<leader>cr` reset connection | |

## Make / quickfix / grep
`<leader>mm` :make and open quickfix; `<leader>qo`/`qc` open/close; `]q` `[q` next/prev.
`<leader>gg` :grep (rg --vimgrep if installed); `<leader>*` grep word under cursor.

## gdb (termdebug, built-in)
`<leader>dd` :Termdebug (type `./a.out`), `db` Break, `dx` Clear, `ds` Step,
`dn` Over, `dc` Continue, `df` Finish, `de` Evaluate.

## Files
`<leader>e` netrw :Explore (tree style, no banner). `<leader>ff` CtrlP files
(falls back to `:find`), `<leader>bb` buffers, `<C-p>` CtrlP; uses `rg --files` if present.

## ALE (clangd only, C/C++ buffers)
`gd` definition, `gr` references, `K` hover, `<leader>rn` rename,
`<leader>ca` code action, `]d` `[d` next/prev diagnostic. Omnifunc completion
(`<C-x><C-o>`, plus ALE auto popup). No fixers, no fix-on-save; formatting is
`<leader>=` (clang-format, defined in ftplugin). cppcheck/clang-tidy: see comment in tools.vim.

## Git
Fugitive: `<leader>gs` :Git status, `gb` blame, `gd` :Gdiffsplit. Gitgutter:
`]h` `[h` hunks, `<leader>hs` stage, `hu` undo, `hp` preview.

## Other tools
`valgrind --leak-check=full ./a.out`, `cppcheck --enable=all src/`.
Without plugins everything still loads; only plugin maps are skipped.
