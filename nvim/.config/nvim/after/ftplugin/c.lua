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
