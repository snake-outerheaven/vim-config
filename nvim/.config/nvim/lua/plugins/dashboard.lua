-- Menu inicial em Gruvbox: cabecalho com gradiente, botoes e rodape com os numeros do lazy.nvim.
return {
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            local icons = require("config.icons")

            local logo = {
                "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
                "████╗  ██║██║   ██║██║████╗ ████║",
                "██╔██╗ ██║██║   ██║██║██╔████╔██║",
                "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
                "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
            }

            -- cores do Gruvbox: amarelo -> laranja -> vermelho no cabecalho
            local function highlights()
                local grad = require("config.gradient").steps("#fabd2f", "#fb4934", #logo)
                for i, color in ipairs(grad) do
                    vim.api.nvim_set_hl(0, "AlphaHeader" .. i, { fg = color, bold = true })
                end
                vim.api.nvim_set_hl(0, "AlphaSubtitle", { fg = "#928374", italic = true })
                vim.api.nvim_set_hl(0, "AlphaButton", { fg = "#ebdbb2" })
                vim.api.nvim_set_hl(0, "AlphaShortcut", { fg = "#b8bb26", bold = true })
                vim.api.nvim_set_hl(0, "AlphaFooter", { fg = "#928374", italic = true })
            end
            highlights()
            vim.api.nvim_create_autocmd("ColorScheme", { callback = highlights })

            local header = { type = "group", val = {}, opts = { position = "center" } }
            for i, line in ipairs(logo) do
                header.val[i] = { type = "text", val = line, opts = { hl = "AlphaHeader" .. i, position = "center" } }
            end
            local subtitle = { type = "text", val = "C / C++   ·   estilo kernel", opts = { hl = "AlphaSubtitle", position = "center" } }

            local function button(key, label, icon, cmd)
                local b = dashboard.button(key, icon .. "  " .. label, cmd)
                b.opts.hl = "AlphaButton"
                b.opts.hl_shortcut = "AlphaShortcut"
                return b
            end

            local buttons = {
                type = "group",
                val = {
                    button("f", "Buscar arquivo", icons.find, "<cmd>Telescope find_files<CR>"),
                    button("g", "Buscar texto (rg)", icons.grep, "<cmd>Telescope live_grep<CR>"),
                    button("r", "Arquivos recentes", icons.recent, "<cmd>Telescope oldfiles<CR>"),
                    button("e", "Explorar pasta", icons.folder, "<cmd>Oil<CR>"),
                    button("n", "Novo arquivo", icons.new, "<cmd>enew<CR>"),
                    button("c", "Configuracao", icons.config, "<cmd>edit " .. vim.fn.stdpath("config") .. "/init.lua<CR>"),
                    button("l", "Plugins", icons.plug, "<cmd>Lazy<CR>"),
                    button("q", "Sair", icons.quit, "<cmd>qa<CR>"),
                },
                opts = { spacing = 1 },
            }

            local footer = { type = "text", val = "", opts = { hl = "AlphaFooter", position = "center" } }

            dashboard.config.layout = {
                { type = "padding", val = math.max(2, math.floor(vim.o.lines * 0.18)) },
                header,
                { type = "padding", val = 1 },
                subtitle,
                { type = "padding", val = 2 },
                buttons,
                { type = "padding", val = 2 },
                footer,
            }
            dashboard.config.opts.noautocmd = true
            alpha.setup(dashboard.config)

            -- rodape com plugins carregados, tempo de inicio e versao do nvim
            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
                    local v = vim.version()
                    footer.val = string.format("%d plugins em %s ms   ·   nvim %d.%d.%d", stats.loaded, ms, v.major, v.minor, v.patch)
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })

            -- no dashboard: sem numeros, sem coluna de sinais, sem dobras
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "alpha",
                callback = function()
                    vim.opt_local.number = false
                    vim.opt_local.relativenumber = false
                    vim.opt_local.signcolumn = "no"
                    vim.opt_local.foldenable = false
                    vim.opt_local.list = false
                    vim.opt_local.cursorline = false
                end,
            })
        end,
    },
}
