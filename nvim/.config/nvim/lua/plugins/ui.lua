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

    -- status line: modo, git (branch e diff), arquivo, diagnosticos, clangd, posicao
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function()
            local icons = require("config.icons")
            local function lsp_names()
                local names = {}
                for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do names[#names + 1] = c.name end
                if #names == 0 then return "" end
                return icons.lsp .. " " .. table.concat(names, ",")
            end
            local function diff_source()
                local d = vim.b.gitsigns_status_dict
                if d then return { added = d.added, modified = d.changed, removed = d.removed } end
            end
            return {
                options = {
                    theme = "gruvbox",
                    globalstatus = true,
                    component_separators = "",
                    section_separators = { left = icons.sep_right, right = icons.sep_left },
                    disabled_filetypes = { statusline = { "alpha" } },
                },
                sections = {
                    lualine_a = { { "mode", icon = icons.vim } },
                    lualine_b = {
                        { "branch", icon = icons.branch },
                        { "diff", source = diff_source, symbols = { added = "+", modified = "~", removed = "-" } },
                    },
                    lualine_c = {
                        { "filename", path = 1, symbols = { modified = " " .. icons.modified, readonly = " " .. icons.readonly } },
                        { "diagnostics", symbols = { error = "E", warn = "W", info = "I", hint = "H" } },
                    },
                    lualine_x = { { "searchcount" }, { lsp_names }, "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = { lualine_c = { "filename" }, lualine_x = { "location" } },
                extensions = { "quickfix", "lazy", "trouble" },
            }
        end,
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
