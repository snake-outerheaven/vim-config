local o = vim.opt

o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.termguicolors = true
o.scrolloff = 8
o.wrap = false

-- indentacao: 4 espacos (Lua, C e Python ficam bem; ajuste por tipo de arquivo se precisar)
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true

-- busca
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- janelas e arquivos
o.splitright = true
o.splitbelow = true
o.undofile = true        -- desfazer persiste entre sessoes
o.swapfile = false
o.updatetime = 250
o.mouse = "a"
o.clipboard = "unnamedplus"   -- usa wl-clipboard no Sway
o.completeopt = { "menu", "menuone", "noselect" }
