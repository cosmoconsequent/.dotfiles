vim.keymap.set("n", "K", function()
  vim.cmd.RustLsp({ "hover", "actions" })
end, { silent = true, buffer = 0, desc = "Hover actions (Rust)" })

vim.keymap.set("n", "J", function()
  vim.cmd.RustLsp("joinLines")
end, { silent = true, buffer = 0, desc = "[J]oin lines (Rust)" })

vim.keymap.set("n", "gra", function()
  vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = 0, desc = "[G]oto [R]efactor grouped [A]ctions (Rust)" })

vim.keymap.set(
  "x",
  "gra",
  ":RustLsp codeAction<CR>",
  { silent = true, buffer = 0, desc = "[G]oto [R]efactor grouped [A]ctions (Rust)" }
)

vim.keymap.set("n", "<leader>cm", function()
  vim.cmd.RustLsp("expandMacro")
end, { silent = true, buffer = 0, desc = "[C]ode expand [M]acro (Rust)" })

vim.keymap.set("n", "<leader>ce", function()
  vim.cmd.RustLsp("explainError")
end, { silent = true, buffer = 0, desc = "[C]ode explain [E]rror (Rust)" })

vim.keymap.set("n", "<leader>cd", function()
  vim.cmd.RustLsp("renderDiagnostic")
end, { silent = true, buffer = 0, desc = "[C]ode render [D]iagnostic (Rust)" })

vim.keymap.set("n", "<leader>ck", function()
  vim.cmd.RustLsp("openDocs")
end, { silent = true, buffer = 0, desc = "[C]ode open docs (Rust)" })
