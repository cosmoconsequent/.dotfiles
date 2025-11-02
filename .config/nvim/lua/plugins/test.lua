return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",

      -- adapters
      "alfaix/neotest-gtest",
      "rouge8/neotest-rust",
      "fredrikaverpil/neotest-golang",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-jest",
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-gtest").setup({}),
          require("neotest-rust"),
          require("neotest-golang"),
          require("neotest-python"),
          require("neotest-jest")({
            jestCommand = "npm test --",
            jestConfigFile = "custom.jest.config.ts",
            env = { CI = true },
            cwd = function(_) -- path
              return vim.fn.getcwd()
            end,
          }),
        },
      })
    end,
    keys = {
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Neo[T]est: Run [N]earest",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Neo[T]est: Run Current [F]ile",
      },
      {
        "<leader>tc",
        function()
          require("neotest").run.run(vim.uv.cwd())
        end,
        desc = "Neo[T]est: Run Files in [C]wd",
      },
      {
        "<leader>ts",
        function()
          require("neotest").run.run({ suite = true })
        end,
        desc = "Neo[T]est: Run Project [S]uite",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Neo[T]est: Run [L]ast",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Neo[T]est: [A]ttach Nearest",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.stop()
        end,
        desc = "Neo[T]est: [T]erminate",
      },
      {
        "<leader>tu",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Neo[T]est: Toggle Summary [U]I",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Neo[T]est: Toggle [O]utput Panel",
      },
      {
        "<leader>th",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Neo[T]est: Show Output [H]over",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Neo[T]est: [D]ebug Nearest",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Neo[T]est: [D]ebug Current File",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Neo[T]est: Toggle [W]atch Current File",
      },
    },
  },
}
