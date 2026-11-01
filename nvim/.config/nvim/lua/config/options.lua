local o = vim.opt

o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.termguicolors = true
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.mouse = "a"
o.showmode = false                 -- a lualine ja mostra o modo
o.laststatus = 3                   -- uma barra de status global
o.clipboard = "unnamedplus"        -- wl-clipboard no Sway
o.undofile = true
o.swapfile = false
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.inccommand = "split"
o.completeopt = { "menu", "menuone", "noselect" }
o.pumheight = 12
o.list = true
o.listchars = { tab = "› ", trail = "·", extends = "›", precedes = "‹", nbsp = "␣" }
o.fillchars = { eob = " " }

-- dobras pelo treesitter, todas abertas ao iniciar
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevelstart = 99

-- estilo kernel: tabs de 8 (aplicado por tipo em after/ftplugin/c.lua)
o.tabstop = 8
o.shiftwidth = 8
o.expandtab = false

if vim.fn.executable("rg") == 1 then
    o.grepprg = "rg --vimgrep --smart-case"
    o.grepformat = "%f:%l:%c:%m"
end
o.makeprg = "make"
