local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Salvar" })
map("n", "<leader>Q", "<cmd>quit<CR>", { desc = "Sair" })
map("n", "<leader><CR>", "<cmd>nohlsearch<CR>", { desc = "Limpar busca" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map("n", "Y", "y$")

-- janelas (h/j/k/l como no Sway) e buffers
for _, k in ipairs({ "h", "j", "k", "l" }) do map("n", "<C-" .. k .. ">", "<C-w>" .. k) end
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Proximo buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "<leader><Tab>", "<C-^>", { desc = "Buffer alternado" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Fechar buffer" })

-- mover linhas e manter selecao ao indentar
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "<", "<gv")
map("v", ">", ">gv")

-- compilar: :make e abre o quickfix so se houver erros
map("n", "<leader>mm", "<cmd>silent make | redraw! | cwindow<CR>", { desc = "make" })
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Abrir quickfix" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Fechar quickfix" })
map("n", "]q", "<cmd>cnext<CR>", { desc = "Proximo erro" })
map("n", "[q", "<cmd>cprevious<CR>", { desc = "Erro anterior" })

-- man de libc (secao 3) para a palavra sob o cursor; o K fica com o clangd
map("n", "<leader>k", function()
    vim.cmd("Man 3 " .. vim.fn.expand("<cword>"))
end, { desc = "man 3 da palavra" })
