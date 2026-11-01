-- Estilo do kernel Linux (Documentation/process/coding-style.rst), so neste buffer.
local bo, wo = vim.bo, vim.wo
bo.expandtab = false
bo.tabstop = 8
bo.shiftwidth = 8
bo.softtabstop = 0
bo.textwidth = 80
bo.cindent = true
bo.cinoptions = ":0,l1,t0,g0,(0,u0,w1,Ws"
bo.formatoptions = "croqlj"
wo.colorcolumn = "81"

-- espaco no fim da linha e espaco antes de tab ficam em vermelho
if not vim.w.kernel_ws then
    vim.w.kernel_ws = { vim.fn.matchadd("Error", [[\s\+$]], 10), vim.fn.matchadd("Error", [[ \+\ze\t]], 10) }
end

-- clang-format no buffer inteiro ou na selecao, mantendo o cursor
local function format(first, last)
    if vim.fn.executable("clang-format") ~= 1 then
        vim.notify("clang-format nao encontrado", vim.log.levels.WARN)
        return
    end
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then name = "x.c" end
    local has_local = #vim.fs.find({ ".clang-format", "_clang-format" },
        { path = vim.fs.dirname(name), upward = true }) > 0
    local home = vim.fn.expand("~/.clang-format")
    local style = (not has_local and vim.fn.filereadable(home) == 1) and ("--style=file:" .. home) or "--style=file"
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local out = vim.fn.system({ "clang-format", style, "--assume-filename=" .. name,
        "--lines=" .. first .. ":" .. last }, table.concat(lines, "\n") .. "\n")
    if vim.v.shell_error ~= 0 then
        vim.notify("clang-format falhou", vim.log.levels.ERROR)
        return
    end
    local new = vim.split(out, "\n", { plain = true })
    if new[#new] == "" then table.remove(new) end
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, new)
    vim.fn.winrestview(view)
end

vim.keymap.set("n", "<leader>=", function() format(1, vim.fn.line("$")) end, { buffer = true })
vim.keymap.set("x", "<leader>=", function()
    local a, b = vim.fn.line("v"), vim.fn.line(".")
    vim.cmd("normal! \27")
    format(math.min(a, b), math.max(a, b))
end, { buffer = true })
