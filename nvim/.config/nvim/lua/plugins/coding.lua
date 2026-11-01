-- Sintaxe, completar, snippets e formatar.
return {
    -- nvim-treesitter: a branch master e a que roda no Neovim 0.10 (a main exige 0.12)
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdate", "TSInstall" },
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = { "c", "cpp", "cmake", "make", "lua", "vim", "vimdoc", "bash",
                "markdown", "markdown_inline", "json", "yaml", "diff", "gitcommit" },
            highlight = { enable = true },
            indent = { enable = false },       -- no C o 'cindent' do estilo kernel faz melhor
            incremental_selection = {
                enable = true,
                keymaps = { init_selection = "<C-space>", node_incremental = "<C-space>", node_decremental = "<BS>" },
            },
        },
    },

    -- completar (nvim-cmp roda no 0.10 sem ajustes)
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp",
                dependencies = { "rafamadriz/friendly-snippets" } },
        },
        config = function()
            local cmp, luasnip = require("cmp"), require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()
            cmp.setup({
                snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
                window = { completion = cmp.config.window.bordered(), documentation = cmp.config.window.bordered() },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then luasnip.jump(-1)
                        else fallback() end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources(
                    { { name = "nvim_lsp" }, { name = "luasnip" } },
                    { { name = "path" }, { name = "buffer" } }
                ),
            })
        end,
    },

    -- clang-format ao salvar ou na mao (usa o .clang-format do projeto, ou ~/.clang-format)
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = "ConformInfo",
        keys = {
            { "<leader>=", function() require("conform").format({ async = true, lsp_format = "never" }) end,
                mode = { "n", "x" }, desc = "Formatar (clang-format)" },
        },
        opts = {
            formatters_by_ft = { c = { "clang-format" }, cpp = { "clang-format" } },
            formatters = {
                ["clang-format"] = {
                    prepend_args = function()
                        local home = vim.fn.expand("~/.clang-format")
                        local has_local = #vim.fs.find({ ".clang-format", "_clang-format" },
                            { path = vim.fn.expand("%:p:h"), upward = true }) > 0
                        if not has_local and vim.fn.filereadable(home) == 1 then
                            return { "--style=file:" .. home }
                        end
                        return {}
                    end,
                },
            },
        },
    },
}
