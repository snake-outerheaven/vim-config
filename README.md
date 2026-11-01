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
nvim/                      stow package: nvim/.config/nvim (Neovim 0.10, lazy.nvim, C/C++ only)
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

## Neovim (optional)

`nvim/` is a stow package (`nvim/.config/nvim`) with a modern Neovim setup for
C/C++ only, in the kernel style of the Vim config. Plain Vim ignores it. Target is
**Neovim 0.10** (Debian 13 ships 0.10.4): LSP and inlay hints use the built-in API,
and there is no nvim-lspconfig (current releases need 0.11.3+). nvim-treesitter is
pinned to its `master` branch (`main` needs 0.12) and telescope to `0.1.x`.

| Area | Plugins |
|---|---|
| Look | gruvbox.nvim, lualine, bufferline, noice + nvim-notify, indent-blankline, which-key |
| Find / move | telescope (+ fzf-native), oil, flash, trouble, todo-comments |
| Code | nvim-treesitter, nvim-cmp + LuaSnip, conform (clang-format), nvim-autopairs, mini.surround |
| C/C++ | clangd (built-in LSP), cmake-tools, nvim-dap + dap-ui with gdb 14+ (native DAP) |
| Git | gitsigns |

Keys (leader is Space; which-key lists them): `<leader>ff/fg/fb` files/grep/buffers,
`<leader>e` oil, `gd gr gi K` LSP (K = floating docs), `<leader>ch` switch .c/.h,
`<leader>=` clang-format, `<leader>mm` :make, `<leader>cg/cb/cr` CMake,
`<leader>db/dd/dn/ds/du` debugger, `<leader>k` man 3 of the word, `<leader>xx` diagnostics.

```sh
sudo apt install neovim clangd clang-format clang-tidy gdb cmake bear ripgrep fd-find build-essential git stow
cd ~/.vim && stow --no-folding -t ~ nvim
nvim            # first start clones lazy.nvim and the plugins (needs git and network)
```

After the first successful start, commit `nvim/.config/nvim/lazy-lock.json` to pin
the working plugin versions (`:Lazy restore` goes back to them). clangd needs
`compile_commands.json`: run `bin/mkproject.sh` in the project.

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
