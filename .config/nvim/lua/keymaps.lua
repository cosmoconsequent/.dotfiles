vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>l", vim.diagnostic.setloclist, { desc = "Open diagnostic [L]ocation list" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")

vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "=ap", "mz=ap'z")

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d') -- "discard" as black hole delete

vim.keymap.set({ "n", "v" }, "<leader>a", "ggVG")
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Remove trailing whitespace when writing file",
  group = vim.api.nvim_create_augroup("clear-whitespace", { clear = true }),
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
