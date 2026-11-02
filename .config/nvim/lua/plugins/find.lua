return {
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    opts = {
      "max-perf",
      grep = { rg_glob = true },
      lsp = { symbols = { locate = true } },
      ui_select = {},
      winopts = {
        border = "border-top",
        fullscreen = true,
        preview = { horizontal = "right:50%" },
      },
    },
    keys = {
      {
        "<leader>fh",
        function()
          require("fzf-lua").helptags()
        end,
        desc = "[F]ind [H]elp",
      },
      {
        "<leader>fk",
        function()
          require("fzf-lua").keymaps()
        end,
        desc = "[F]ind [K]eymaps",
      },
      {
        "<leader>fr",
        function()
          require("fzf-lua").resume()
        end,
        desc = "[F]ind [R]esume",
      },
      {
        "<leader>ff",
        function()
          require("fzf-lua").files()
        end,
        desc = "[F]ind [F]iles",
      },
      {
        "<leader>fp",
        function()
          require("fzf-lua").oldfiles()
        end,
        desc = "[F]ind [P]revious files",
      },
      {
        "<leader>fn",
        function()
          require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "[F]ind [N]eovim files",
      },
      {
        "<leader>fb",
        function()
          require("fzf-lua").buffers()
        end,
        desc = "[F]ind [B]uffers",
      },
      {
        "<leader>fl",
        function()
          require("fzf-lua").blines()
        end,
        desc = "[F]ind current buffer [L]ines",
      },
      {
        "<leader>fL",
        function()
          require("fzf-lua").lines()
        end,
        desc = "[F]ind all buffer [L]ines",
      },
      {
        "<leader>fs",
        function()
          require("fzf-lua").lsp_document_symbols()
        end,
        desc = "[F]ind document [S]ymbols",
      },
      {
        "<leader>fS",
        function()
          require("fzf-lua").lsp_live_workspace_symbols()
        end,
        desc = "[F]ind workspace [S]ymbols",
      },
      {
        "<leader>fd",
        function()
          require("fzf-lua").diagnostics_document()
        end,
        desc = "[F]ind document [D]iagnostics",
      },
      {
        "<leader>fD",
        function()
          require("fzf-lua").diagnostics_workspace()
        end,
        desc = "[F]ind workspace [D]iagnostics",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").live_grep()
        end,
        desc = "[F]ind by [G]rep",
      },
      {
        "<leader>ft",
        function()
          require("fzf-lua").grep_cword()
        end,
        desc = "[F]ind word [T]ext",
      },
      {
        "<leader>ft",
        function()
          require("fzf-lua").grep_visual()
        end,
        mode = "x",
        desc = "[F]ind selected [T]ext",
      },
    },
  },

  {
    "stevearc/aerial.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
    keys = {
      {
        "<leader>fo",
        function()
          require("aerial").fzf_lua_picker({ fzf_opts = { ["--layout"] = "reverse" } })
        end,
        desc = "[F]ind document [O]utline",
      },
    },
  },

  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>fc",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "[F]ind and [C]hange in project files",
      },
    },
  },
}
