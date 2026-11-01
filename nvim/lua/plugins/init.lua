return {
    -- tema Gruvbox escuro, igual ao resto do rice
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({ contrast = "hard", transparent_mode = false })
            vim.o.background = "dark"
            vim.cmd.colorscheme("gruvbox")
        end,
    },

    -- barra de status
    {
        "nvim-lualine/lualine.nvim",
        opts = { options = { theme = "gruvbox", section_separators = "", component_separators = "|" } },
    },

    -- buscador de arquivos e texto (ripgrep e fd-find ja estao no install-debian.sh)
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Arquivos" },
            { "<leader>g", "<cmd>Telescope live_grep<CR>",  desc = "Buscar texto" },
            { "<leader>b", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
            { "<leader>h", "<cmd>Telescope help_tags<CR>",  desc = "Ajuda" },
        },
    },

    -- marcas de git na margem
    { "lewis6991/gitsigns.nvim", opts = {} },

    -- mostra os atalhos disponiveis ao apertar espaco
    { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
}
