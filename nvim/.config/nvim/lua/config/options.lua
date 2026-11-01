local o = vim.opt

o.number = true
o.relativenumber = false
o.cursorline = true
o.signcolumn = "yes"
o.termguicolors = true
o.scrolloff = 5
o.wrap = false
o.mouse = "a"
o.clipboard = "unnamedplus"        -- wl-clipboard no Sway
o.undofile = true
o.swapfile = false
o.splitright = true
o.splitbelow = true
o.ignorecase = true
o.smartcase = true
o.list = true
o.listchars = { tab = "› ", trail = "·", extends = "›", precedes = "‹", nbsp = "␣" }

-- estilo kernel: tabs de 8 (aplicado por tipo em after/ftplugin/c.lua e cpp.lua)
o.tabstop = 8
o.shiftwidth = 8
o.expandtab = false

-- ferramentas externas
if vim.fn.executable("rg") == 1 then
    o.grepprg = "rg --vimgrep --smart-case"
    o.grepformat = "%f:%l:%c:%m"
end
o.makeprg = "make"

-- tema embutido; cai para outro se o nvim for antigo
if not pcall(vim.cmd.colorscheme, "retrobox") then
    pcall(vim.cmd.colorscheme, "habamax")
end

-- gdb dentro do nvim (termdebug vem no nvim)
vim.g.termdebug_wide = 163
vim.cmd("packadd termdebug")
