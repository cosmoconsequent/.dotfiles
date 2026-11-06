return {
  -- editing enhancements
  "tpope/vim-sleuth",

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = {
      n_lines = 50,
    },
  },

  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Toggle [U]ndotree" },
    },
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy", -- drag-and-drop
    opts = {},
    keys = {
      { "<leader>i", "<cmd>PasteImage<CR>", desc = "Paste [I]mage from clipboard" },
    },
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

  -- zen buffer doesn't update lualine, maybe fix sometime
  {
    "folke/zen-mode.nvim",
    opts = {
      window = { backdrop = 1 },
    },
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle [Z]en Mode" },
    },
  },

  {
    "laytan/cloak.nvim",
    opts = {},
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { lsp = { enabled = true } },
    },
  },

  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = ":call mkdp#util#install()",
  },
}
