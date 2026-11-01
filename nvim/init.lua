-- init.lua: ponto de entrada. Opcoes e atalhos em lua/config, plugins em lua/plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
