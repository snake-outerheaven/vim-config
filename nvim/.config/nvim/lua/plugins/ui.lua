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

    -- Discord Rich Presence. Por privacidade nao mostra nome de arquivo, projeto, linha nem botoes;
    -- para mostrar tudo, apague os campos *_text e coloque enable_line_number = true.
    {
        "andweeb/presence.nvim",
        event = "VeryLazy",
        opts = {
            neovim_image_text = "Neovim",
            editing_text = "Programando em C/C++",
            reading_text = "Lendo codigo",
            workspace_text = "No terminal",
            git_commit_text = "Escrevendo um commit",
            file_explorer_text = "Navegando em arquivos",
            plugin_manager_text = "Atualizando plugins",
            line_number_text = "",
            enable_line_number = false,
            buttons = false,
            show_time = true,
        },
    },
}
