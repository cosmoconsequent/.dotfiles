return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mason-org/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",

      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",

      {
        "igorlfs/nvim-dap-view",
        opts = {},
        windows = {
          terminal = {
            hide = { "go" },
          },
        },
      },
    },
    config = function()
      local dap = require("dap")

      require("mason-nvim-dap").setup({
        automatic_installation = true,
        handlers = {},
        ensure_installed = {
          "codelldb",
          "delve",
          "python",
          "js",
          "bash",
        },
      })

      -- c/c++/rust
      dap.adapters.codelldb = {
        type = "executable",
        command = "codelldb",
      }

      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- go
      require("dap-go").setup()

      -- python
      require("dap-python").setup("debugpy-adapter")

      -- javascript/typescript
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }

      dap.configurations.javascript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
      }

      dap.configurations.typescript = dap.configurations.javascript

      -- bash
      dap.adapters.bashdb = {
        type = "executable",
        command = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
        name = "bashdb",
      }

      dap.configurations.sh = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch file",
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathCat = "cat",
          pathBash = "/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          argsString = "",
          env = {},
          terminalKind = "integrated",
        },
      }

      -- better breakpoints
      vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
      vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
      local breakpoint_icons = {
        Breakpoint = "●",
        BreakpointCondition = "⊜",
        BreakpointRejected = "⊘",
        LogPoint = "◆",
        Stopped = "⭔",
      }
      for type, icon in pairs(breakpoint_icons) do
        local tp = "Dap" .. type
        local hl = (type == "Stopped") and "DapStop" or "DapBreak"
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end
    end,
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "[D]ebug: Toggle [B]reakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "[D]ebug: Set [B]reakpoint with Condition",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "[D]ebug: Start/[C]ontinue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "[D]ebug: Run to [C]ursor",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "[D]ebug: Run [L]ast",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "[D]ebug: Step [O]ver",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "[D]ebug: Step [I]nto",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "[D]ebug: Step [O]ut",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "[D]ebug: [G]o to Line (No Execute)",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "[D]ebug: [D]own",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "[D]ebug: [U]p",
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "[D]ebug: [H]over",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "[D]ebug: [S]ession",
      },
      {
        "<leader>dv",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes, { border = "rounded" })
        end,
        desc = "[D]ebug: [V]ariables",
      },
      {
        "<leader>dw",
        function()
          vim.cmd("DapViewWatch")
        end,
        desc = "[D]ebug: Add [W]atch",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "[D]ebug: [P]ause",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "[D]ebug: [T]erminate",
      },
      {
        "<leader>du",
        function()
          vim.cmd("DapViewToggle!")
        end,
        desc = "[D]ebug: Toggle DapView [U]I",
      },
      {
        "<leader>dr",
        function()
          vim.cmd("DapViewJump repl")
        end,
        desc = "[D]ebug: Toggle [R]EPL",
      },
    },
  },
}
