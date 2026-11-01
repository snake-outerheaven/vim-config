-- Utilidades de edicao: buscar, navegar, arquivos, diagnosticos.
return {
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",                       -- a linha estavel que roda no 0.10
        cmd = "Telescope",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = function() return vim.fn.executable("make") == 1 end },
        },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Arquivos" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto (rg)" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
            { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recentes" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Simbolos do arquivo" },
            { "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Simbolos do projeto" },
            { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnosticos" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Ajuda" },
            { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Atalhos" },
            { "<leader>*", "<cmd>Telescope grep_string<CR>", desc = "Buscar a palavra" },
        },
        config = function()
            local t = require("telescope")
            t.setup({ defaults = { layout_strategy = "horizontal", sorting_strategy = "ascending",
                layout_config = { prompt_position = "top" } } })
            pcall(t.load_extension, "fzf")
        end,
    },

    -- arquivos como um buffer editavel (substitui netrw)
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        keys = { { "<leader>e", "<cmd>Oil<CR>", desc = "Arquivos (oil)" } },
        opts = { default_file_explorer = true, view_options = { show_hidden = true } },
    },

    -- pular para qualquer lugar da tela
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        },
    },

    -- lista de diagnosticos / quickfix / referencias
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnosticos" },
            { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Diagnosticos do buffer" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix" },
            { "<leader>xr", "<cmd>Trouble lsp_references toggle<CR>", desc = "Referencias" },
        },
    },

    -- destaca e lista TODO / FIXME / HACK
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = { { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "TODOs" } },
    },

    -- cercar / trocar / remover delimitadores: gsa, gsd, gsr (o 's' fica livre para o flash)
    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = { mappings = { add = "gsa", delete = "gsd", replace = "gsr", find = "gsf",
            find_left = "gsF", highlight = "gsh", update_n_lines = "gsn" } },
    },
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
}
