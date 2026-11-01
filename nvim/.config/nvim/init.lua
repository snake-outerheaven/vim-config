-- Neovim moderno focado em C/C++ (estilo kernel). Alvo: Neovim 0.10 (Debian 13 traz 0.10.4).
-- LSP e inlay hints usam a API nativa do 0.10; nao ha nvim-lspconfig (as versoes atuais exigem 0.11+).
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lsp")
require("config.lazy")
