-- Gerenciador de plugins lazy.nvim (se instala sozinho na primeira abertura; precisa de git e rede)
local path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(path) then
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
        "https://github.com/folke/lazy.nvim.git", path })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({ { "Falha ao instalar o lazy.nvim:\n" .. out, "ErrorMsg" } }, true, {})
        return  -- segue sem plugins: o nvim continua usavel
    end
end
vim.opt.rtp:prepend(path)

require("lazy").setup("plugins", {
    change_detection = { notify = false },
    install = { colorscheme = { "gruvbox", "habamax" } },
})
