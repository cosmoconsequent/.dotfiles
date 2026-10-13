return {
  {
    "coder/claudecode.nvim",
    lazy = false,
    opts = {
      terminal = {
        provider = "none",
      },
    },
    keys = {
      { "<leader>cs", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "[C]ode [S]end buffer to AI" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "[C]ode [S]end selection to AI" },
      { "<leader>cs", "<cmd>ClaudeCodeTreeAdd<cr>", mode = "n", ft = { "netrw" }, desc = "[C]ode [S]end file to AI" },
    },
  },
}
