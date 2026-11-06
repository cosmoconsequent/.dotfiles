return {
  {
    "coder/claudecode.nvim",
    event = "VeryLazy",
    opts = {
      terminal = {
        provider = "none",
      },
    },
    keys = {
      { "<leader>cs", "<cmd>ClaudeCodeAdd %<cr>", desc = "[C]ode [S]end buffer to AI" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "x", desc = "[C]ode [S]end selection to AI" },
      { "<leader>cs", "<cmd>ClaudeCodeTreeAdd<cr>", ft = { "netrw" }, desc = "[C]ode [S]end file to AI" },
    },
  },
}
