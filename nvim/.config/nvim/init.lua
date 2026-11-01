-- Neovim para C/C++ no estilo kernel. Sem plugins, sem downloads: so o que vem no nvim.
-- Espelha o vimrc deste repo (Vim): o que o Emacs fazia com compile/eglot/gdb/dired
-- aqui e :make + quickfix, LSP nativo (clangd), termdebug e netrw.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lsp")
