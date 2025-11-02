return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- "Only load luvit types when the `vim.uv` word is found"
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- editing enhancements
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({ n_lines = 500 })
    end,
  },

  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle [U]ndotree" })
    end,
  },

  -- visual utils
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        icons_enabled = false,
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = {},
        lualine_b = {
          { "filename", path = 1 },
          "branch",
          "diff",
          { "diagnostics", colored = false },
        },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          "filetype",
          { "encoding", show_bomb = true },
          "lsp_status",
          "location",
          "progress",
        },
        lualine_z = {},
      },
    },
  },

  {
    "stevearc/aerial.nvim",
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("aerial").setup()
      vim.keymap.set("n", "<leader>co", "<cmd>AerialToggle!<CR>", { desc = "Toggle [C]ode [O]utline" })
    end,
  },

  {
    "folke/trouble.nvim",
    opts = {
      icons = {},
      use_diagnostic_signs = true,
    },
    keys = {
      {
        "<leader>ct",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "[C]ode [T]rouble current buffer",
      },
      { "<leader>cT", "<cmd>Trouble diagnostics toggle<cr>", desc = "[C]ode [T]rouble workspace" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/[Q]uickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/[Q]uickfix Item",
      },
    },
  },

  {
    "folke/zen-mode.nvim",
    config = function()
      -- zen buffer doesn't update lualine, maybe fix sometime
      require("zen-mode").setup({
        window = {
          backdrop = 1,
        },
      })
      vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle [Z]en Mode" })
    end,
  },

  {
    "laytan/cloak.nvim",
    config = function()
      require("cloak").setup({
        enabled = true,
        cloak_character = "*",
        highlight_group = "Comment",
        cloak_length = nil,
        try_all_patterns = true,
        cloak_telescope = true,
        cloak_on_leave = false,
        patterns = {
          {
            file_pattern = ".env*",
            cloak_pattern = "=.+",
            replace = nil,
          },
        },
      })
    end,
  },

  {
    "toppair/peek.nvim",
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      require("peek").setup()
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
  },
}
