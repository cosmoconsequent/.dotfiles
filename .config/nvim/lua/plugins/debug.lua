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
        opts = {
          windows = {
            terminal = {
              hide = { "go" },
            },
          },
        },
      },
    },
    config = function()
      local dap = require("dap")

      require("mason-nvim-dap").setup({
        ensure_installed = {
          "codelldb", -- rust
          "delve",
          "js",
        },
      })

      -- c/c++
      dap.adapters["lldb-dap"] = {
        type = "executable",
        command = "lldb-dap",
      }

      local input_program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end

      dap.configurations.c = {
        {
          name = "Launch file",
          type = "lldb-dap",
          request = "launch",
          program = input_program,
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        {
          name = "Launch file (args)",
          type = "lldb-dap",
          request = "launch",
          program = input_program,
          args = function()
            return require("dap.utils").splitstr(vim.fn.input("Args: "))
          end,
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
        },
        {
          name = "Attach to process",
          type = "lldb-dap",
          request = "attach",
          pid = require("dap.utils").pick_process,
        },
        {
          name = "Load coredump",
          type = "lldb-dap",
          request = "attach",
          program = input_program,
          coreFile = function()
            return vim.fn.input("Path to coredump file: ", vim.fn.getcwd() .. "/", "file")
          end,
        },
      }

      dap.configurations.cpp = dap.configurations.c

      -- rust via rustaceanvim

      -- go
      require("dap-go").setup()

      -- python
      require("dap-python").setup("uv")

      -- js / ts
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }

      dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]

      dap.configurations.javascript = {
        {
          name = "Launch file",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          name = "Attach to process",
          type = "pwa-node",
          request = "attach",
          processId = function()
            return require("dap.utils").pick_process({ filter = "node" })
          end,
        },
        {
          name = "Launch Chrome (port 5173)",
          type = "pwa-chrome",
          request = "launch",
          url = "http://localhost:5173",
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
        -- google-chrome-stable --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-debug
        {
          name = "Attach to Chrome (port 9222)",
          type = "pwa-chrome",
          request = "attach",
          port = 9222,
          webRoot = "${workspaceFolder}",
          sourceMaps = true,
        },
      }

      dap.configurations.typescript = dap.configurations.javascript
      dap.configurations.javascriptreact = dap.configurations.javascript
      dap.configurations.typescriptreact = dap.configurations.javascript

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
        "<C-n>",
        function()
          require("dap").step_over()
        end,
        desc = "[D]ebug: Step [O]ver (repeat)",
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
