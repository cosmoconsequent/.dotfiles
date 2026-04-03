return {
  {
    "github/copilot.vim",
    init = function()
      -- on-demand suggestions with alt+\
      vim.g.copilot_enabled = 0
    end,
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    opts = {
      model = "gemini-3.1-pro-preview",
    },
    keys = {
      {
        "<leader>cc",
        function()
          require("CopilotChat").toggle()
        end,
        mode = { "n", "x" },
        desc = "[C]ode toggle Copilot [C]hat",
      },
    },
  },
}
