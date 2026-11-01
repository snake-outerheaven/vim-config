local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar destaque da busca" })

-- janelas (h/j/k/l como no Sway)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Proximo buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Fechar buffer" })

-- salvar / sair
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Salvar" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Sair" })

-- mover linhas selecionadas
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- manter selecao ao indentar
map("v", "<", "<gv")
map("v", ">", ">gv")

-- diagnosticos
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Ver diagnostico" })
