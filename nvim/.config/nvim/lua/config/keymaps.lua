local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Salvar" })
map("n", "<leader>Q", "<cmd>quit<CR>", { desc = "Sair" })
map("n", "<leader><CR>", "<cmd>nohlsearch<CR>", { desc = "Limpar busca" })
map("n", "Y", "y$")

-- janelas e buffers
for _, k in ipairs({ "h", "j", "k", "l" }) do map("n", "<C-" .. k .. ">", "<C-w>" .. k) end
map("n", "<leader>n", "<cmd>bnext<CR>")
map("n", "<leader>p", "<cmd>bprevious<CR>")
map("n", "<leader><Tab>", "<C-^>", { desc = "Buffer alternado" })
map("n", "<leader>bl", "<cmd>ls<CR>")
map("n", "<leader>bd", "<cmd>bdelete<CR>")
map("n", "<leader>bb", ":buffer ", { desc = "Ir ao buffer (Tab completa)" })

-- arquivos (dired): netrw em arvore, e :find com Tab completando pelo caminho
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.opt.path:append("**")
map("n", "<leader>e", "<cmd>Explore<CR>", { desc = "Netrw" })
map("n", "<leader>ff", ":find ", { desc = ":find (Tab completa)" })

-- compilar (M-x compile): :make e abre o quickfix so se houver erros
map("n", "<leader>mm", "<cmd>silent make | redraw! | cwindow<CR>", { desc = "make" })
map("n", "<leader>qo", "<cmd>copen<CR>")
map("n", "<leader>qc", "<cmd>cclose<CR>")
map("n", "]q", "<cmd>cnext<CR>")
map("n", "[q", "<cmd>cprevious<CR>")

-- grep (rg)
map("n", "<leader>gg", ":silent grep! ", { desc = "grep" })
map("n", "<leader>*", "<cmd>silent grep! <cword> | copen<CR>", { desc = "grep da palavra" })

-- gdb (termdebug)
map("n", "<leader>dd", "<cmd>Termdebug<CR>")
map("n", "<leader>db", "<cmd>Break<CR>")
map("n", "<leader>dx", "<cmd>Clear<CR>")
map("n", "<leader>ds", "<cmd>Step<CR>")
map("n", "<leader>dn", "<cmd>Over<CR>")
map("n", "<leader>dc", "<cmd>Continue<CR>")
map("n", "<leader>df", "<cmd>Finish<CR>")
map("n", "<leader>de", "<cmd>Evaluate<CR>")
