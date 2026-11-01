-- Icones: usam Nerd Font. Sem Nerd Font, coloque vim.g.have_nerd_font = false em options.lua
-- e tudo volta para ASCII.
local nf = vim.g.have_nerd_font ~= false
local function c(code, fallback) return nf and vim.fn.nr2char(code) or fallback end

return {
    nerd = nf,
    branch = c(0xe0a0, "git:"),
    lsp = c(0xf013, "lsp"),
    vim = c(0xe62b, "nvim"),
    sep_left = c(0xe0b6, ""),     -- borda arredondada esquerda
    sep_right = c(0xe0b4, ""),    -- borda arredondada direita
    modified = c(0xf111, "*"),
    readonly = c(0xf023, "RO"),
    -- botoes do dashboard
    find = c(0xf002, ">"),
    new = c(0xf15b, ">"),
    recent = c(0xf1da, ">"),
    folder = c(0xf07b, ">"),
    grep = c(0xf0b0, ">"),
    config = c(0xf013, ">"),
    plug = c(0xf1e6, ">"),
    quit = c(0xf011, ">"),
}
