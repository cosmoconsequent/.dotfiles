local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "gitcommit",
  "go",
  "gomod",
  "gosum",
  "html",
  "javascript",
  "json",
  "jsonc",
  "latex",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

-- html injects js/css sub-parsers; costly regardless of file size
local highlight_skip = { html = true }
local max_filesize = 1024 * 1024

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
        callback = function(args)
          local buf = args.buf
          local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
          if not lang or highlight_skip[lang] then
            return
          end

          local size = vim.fn.getfsize(vim.api.nvim_buf_get_name(buf))
          if size >= 0 and size > max_filesize then
            return
          end

          if not pcall(vim.treesitter.start, buf, lang) then
            return
          end

          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          selection_modes = {
            ["@function.outer"] = "V",
            ["@class.outer"] = "V",
          },
          include_surrounding_whitespace = true,
        },
        move = {
          set_jumps = true,
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local selections = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      }
      for key, obj in pairs(selections) do
        vim.keymap.set({ "x", "o" }, key, function()
          select.select_textobject(obj, "textobjects")
        end)
      end

      local movements = {
        goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
        goto_next_end = { ["]M"] = "@function.outer", ["]["] = "@class.outer" },
        goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
        goto_previous_end = { ["[M"] = "@function.outer", ["[]"] = "@class.outer" },
      }
      for fn, maps in pairs(movements) do
        for key, obj in pairs(maps) do
          vim.keymap.set({ "n", "x", "o" }, key, function()
            move[fn](obj, "textobjects")
          end)
        end
      end
    end,
  },
}
