-- clangd pelo LSP nativo (o eglot do Emacs): precisa de compile_commands.json,
-- veja bin/mkproject.sh. Sem clangd instalado, nada acontece.
local function start()
    if vim.fn.executable("clangd") ~= 1 then return end
    local name = vim.api.nvim_buf_get_name(0)
    local found = vim.fs.find({ "compile_commands.json", ".clangd", ".git" },
        { path = vim.fs.dirname(name), upward = true })[1]
    vim.lsp.start({
        name = "clangd",
        cmd = { "clangd", "--background-index", "--header-insertion=never" },
        root_dir = found and vim.fs.dirname(found) or vim.fs.dirname(name),
    })
end

vim.api.nvim_create_autocmd("FileType", { pattern = { "c", "cpp" }, callback = start })

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local function m(lhs, fn) vim.keymap.set("n", lhs, fn, { buffer = ev.buf }) end
        m("gd", vim.lsp.buf.definition)
        m("gr", vim.lsp.buf.references)
        m("K", vim.lsp.buf.hover)
        m("<leader>rn", vim.lsp.buf.rename)
        m("<leader>ca", vim.lsp.buf.code_action)
        m("]d", vim.diagnostic.goto_next)
        m("[d", vim.diagnostic.goto_prev)
        m("<leader>E", vim.diagnostic.open_float)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"   -- <C-x><C-o>
    end,
})
