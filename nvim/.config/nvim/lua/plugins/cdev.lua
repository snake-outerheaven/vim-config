-- Ferramentas de C/C++: CMake e depurador.
return {
    -- CMake: gerar, compilar, rodar e escolher o tipo de build
    {
        "Civitasv/cmake-tools.nvim",
        ft = { "c", "cpp", "cmake" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            { "<leader>cg", "<cmd>CMakeGenerate<CR>", desc = "CMake: gerar" },
            { "<leader>cb", "<cmd>CMakeBuild<CR>", desc = "CMake: compilar" },
            { "<leader>cr", "<cmd>CMakeRun<CR>", desc = "CMake: rodar" },
            { "<leader>ct", "<cmd>CMakeSelectBuildType<CR>", desc = "CMake: tipo de build" },
        },
    },

    -- depurador: o gdb 14+ fala DAP sozinho (--interpreter=dap); o Debian 13 traz gdb 16
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
            "theHamsta/nvim-dap-virtual-text",
        },
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Condicao: ")) end, desc = "Breakpoint condicional" },
            { "<leader>dd", function() require("dap").continue() end, desc = "Iniciar / continuar" },
            { "<leader>dn", function() require("dap").step_over() end, desc = "Passar por cima" },
            { "<leader>ds", function() require("dap").step_into() end, desc = "Entrar" },
            { "<leader>df", function() require("dap").step_out() end, desc = "Sair da funcao" },
            { "<leader>dx", function() require("dap").terminate() end, desc = "Encerrar" },
            { "<leader>du", function() require("dapui").toggle() end, desc = "Interface do debug" },
            { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Avaliar" },
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            require("nvim-dap-virtual-text").setup()
            dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

            dap.adapters.gdb = { type = "executable", command = "gdb", args = { "--interpreter=dap", "--eval-command", "set print pretty on" } }
            local launch = {
                name = "Executar (gdb)",
                type = "gdb",
                request = "launch",
                program = function() return vim.fn.input("Executavel: ", vim.fn.getcwd() .. "/", "file") end,
                cwd = "${workspaceFolder}",
            }
            dap.configurations.c = { launch }
            dap.configurations.cpp = { launch }
        end,
    },

    -- git na margem e hunks
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            on_attach = function(buf)
                local gs = require("gitsigns")
                local function m(lhs, fn, desc) vim.keymap.set("n", lhs, fn, { buffer = buf, desc = desc }) end
                m("]h", gs.next_hunk, "Proximo hunk")
                m("[h", gs.prev_hunk, "Hunk anterior")
                m("<leader>gs", gs.stage_hunk, "Stage do hunk")
                m("<leader>gu", gs.undo_stage_hunk, "Desfazer stage")
                m("<leader>gp", gs.preview_hunk, "Ver hunk")
                m("<leader>gb", gs.blame_line, "Blame da linha")
            end,
        },
    },
}
