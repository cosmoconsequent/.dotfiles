return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "diff",
        "go",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "rust",
        "vim",
        "vimdoc",
      },
      auto_install = true,
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local disabled_langs = {
            make = true,
            html = true,
            csv = true,
            yaml = true,
          }

          if disabled_langs[lang] then
            return true
          end

          local max_filesize = 100 * 1024
          local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
          if size >= 0 and size > max_filesize then
            vim.notify(
              "File larger than 100KB, treesitter disabled for performance",
              vim.log.levels.WARN,
              { title = "Treesitter" }
            )
            return true
          end
        end,
        additional_vim_regex_highlighting = { "markdown", "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
            selection_modes = {
              ["@function.outer"] = "V",
              ["@class.outer"] = "V",
            },
            include_surrounding_whitespace = true, -- consistent with `ap`
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      })
    end,
  },
}
