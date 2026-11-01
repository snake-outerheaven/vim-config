-- Visual: tema, barra de status, buffers, mensagens e guias de indentacao.
return {
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("gruvbox").setup({ contrast = "hard" })
            vim.o.background = "dark"
            vim.cmd.colorscheme("gruvbox")
        end,
    },

    { "nvim-tree/nvim-web-devicons", lazy = true },

    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                theme = "gruvbox",
                globalstatus = true,
                section_separators = "",
                component_separators = "|",
            },
            sections = {
                lualine_c = { { "filename", path = 1 }, "diagnostics" },
                lualine_x = { "encoding", "fileformat", "filetype" },
            },
        },
    },

    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        opts = { options = { diagnostics = "nvim_lsp", always_show_bufferline = false } },
    },

    -- cmdline, mensagens e documentacao do LSP em janelas flutuantes
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = { bottom_search = true, command_palette = true, long_message_to_split = true, lsp_doc_border = true },
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        opts = { indent = { char = "│" }, scope = { enabled = true } },
    },

    -- mostra os atalhos disponiveis ao apertar espaco
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>f", group = "buscar" },
                { "<leader>d", group = "debug" },
                { "<leader>c", group = "codigo / cmake" },
                { "<leader>m", group = "make" },
                { "<leader>x", group = "diagnosticos" },
                { "<leader>g", group = "git" },
                { "<leader>u", group = "interface" },
            },
        },
    },
}
