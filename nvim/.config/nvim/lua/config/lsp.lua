-- clangd pelo LSP nativo do Neovim 0.10 (sem nvim-lspconfig). Precisa de compile_commands.json:
-- rode bin/mkproject.sh na raiz do projeto. Sem clangd instalado, nada acontece.

local function capabilities()
    local caps = vim.lsp.protocol.make_client_capabilities()
    local ok, cmp = pcall(require, "cmp_nvim_lsp")   -- completar via nvim-cmp, quando carregado
    if ok then caps = vim.tbl_deep_extend("force", caps, cmp.default_capabilities()) end
    return caps
end

local function start()
    if vim.fn.executable("clangd") ~= 1 then return end
    local name = vim.api.nvim_buf_get_name(0)
    local found = vim.fs.find({ "compile_commands.json", ".clangd", ".git" },
        { path = vim.fs.dirname(name), upward = true })[1]
    vim.lsp.start({
        name = "clangd",
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never",
            "--completion-style=detailed", "--function-arg-placeholders=false" },
        root_dir = found and vim.fs.dirname(found) or vim.fs.dirname(name),
        capabilities = capabilities(),
    })
end

vim.api.nvim_create_autocmd("FileType", { pattern = { "c", "cpp" }, callback = start })

vim.diagnostic.config({
    virtual_text = { prefix = "●" },
    severity_sort = true,
    float = { border = "rounded" },
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- .c <-> .h pelo proprio clangd
local function switch_source_header()
    local clients = vim.lsp.get_clients({ bufnr = 0, name = "clangd" })
    if #clients == 0 then return vim.notify("clangd nao esta ativo", vim.log.levels.WARN) end
    clients[1].request("textDocument/switchSourceHeader", { uri = vim.uri_from_bufnr(0) }, function(_, result)
        if result then vim.cmd.edit(vim.uri_to_fname(result)) else vim.notify("sem arquivo par", vim.log.levels.INFO) end
    end, 0)
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local function m(lhs, fn, desc) vim.keymap.set("n", lhs, fn, { buffer = ev.buf, desc = desc }) end
        m("gd", vim.lsp.buf.definition, "Definicao")
        m("gD", vim.lsp.buf.declaration, "Declaracao")
        m("gi", vim.lsp.buf.implementation, "Implementacao")
        m("gr", vim.lsp.buf.references, "Referencias")
        m("K", vim.lsp.buf.hover, "Documentacao (flutuante)")
        m("<C-s>", vim.lsp.buf.signature_help, "Assinatura")
        m("<leader>rn", vim.lsp.buf.rename, "Renomear")
        m("<leader>ca", vim.lsp.buf.code_action, "Code action")
        m("<leader>ch", switch_source_header, "Alternar .c/.h")
        m("<leader>E", vim.diagnostic.open_float, "Diagnostico")
        m("]d", function() vim.diagnostic.goto_next({ float = false }) end, "Proximo diagnostico")
        m("[d", function() vim.diagnostic.goto_prev({ float = false }) end, "Diagnostico anterior")
        m("<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
        end, "Alternar inlay hints")
        pcall(vim.lsp.inlay_hint.enable, true, { bufnr = ev.buf })
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    end,
})
