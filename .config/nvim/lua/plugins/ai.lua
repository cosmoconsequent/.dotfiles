local copilot_default = {
  adapter = {
    name = "copilot",
    model = "claude-sonnet-4.6", -- 1x
  },
}

return {
  {
    "github/copilot.vim",
    init = function()
      -- on-demand suggestions with alt+\
      vim.g.copilot_enabled = 0
    end,
  },

  {
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCLI",
      "CodeCompanionCmd",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      vim.cmd([[cab ccc CodeCompanionCmd]])
    end,
    opts = {
      display = {
        chat = {
          window = {
            position = "right",
          },
        },
      },
      interactions = {
        chat = copilot_default,
        inline = copilot_default,
        agent = copilot_default,
        cmd = copilot_default,
        background = copilot_default,
        cli = {
          agent = "antigravity",
          agents = {
            antigravity = {
              cmd = "agy",
              args = {},
              description = "Antigravity CLI",
              provider = "terminal",
            },
          },
        },
      },
    },
    keys = {
      -- HTTP
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "[A]I [A]ctions" },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "[A]I [C]hat" },
      { "<leader>ad", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "[A]I a[D]d to chat" },
      { "<leader>ae", "<cmd>CodeCompanion /explain<cr>", mode = "v", desc = "[A]I [E]xplain" },
      { "<leader>af", "<cmd>CodeCompanion /fix<cr>", mode = "v", desc = "[A]I [F]ix" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "[A]I [I]nline" },
      -- CLI
      { "<leader>al", "<cmd>CodeCompanionCLI<cr>", mode = { "n", "v" }, desc = "[A]I C[L]I" },
      {
        "<leader>ap",
        function()
          return require("codecompanion").cli({ prompt = true })
        end,
        mode = { "n", "v" },
        desc = "[A]I CLI [P]rompt",
      }, -- include context with #{this}, #{diagnostics}, #{quickfix}, etc
    },
  },

  {
    "coder/claudecode.nvim",
    opts = {
      terminal = {
        split_width_percentage = 0.5,
      },
      focus_after_send = true,
    },
    keys = {
      { "<leader>at", "<cmd>ClaudeCode<cr>", desc = "[A]I Agen[T]" },
      { "<leader>as", "<cmd>ClaudeCodeAdd %<cr>", mode = "n", desc = "[A]I [S]end buffer to agent" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "[A]I [S]end selection to agent" },
      { "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", mode = "n", ft = { "netrw" }, desc = "[A]I [S]end file to agent" },
    },
  },
}
