return {
  -- diagnostics via LSP, not nvim-lint:
  -- system --
  -- c/cpp: clangd (clang-tidy)
  -- rust: rust-analyzer (clippy)
  -- shell: shellcheck (via bashls)
  -- protobuf: buf
  -- toml: tombi
  -- mason --
  -- cmake: neocmake
  -- lua: lua_ls
  -- html: html

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
        python = { "ruff" },
        javascript = { "biomejs" },
        typescript = { "biomejs" },
        javascriptreact = { "biomejs" },
        typescriptreact = { "biomejs" },
        css = { "biomejs" },
        json = { "biomejs" },
        jsonc = { "biomejs" },
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
        terraform = { "tflint" },
        markdown = { "markdownlint-cli2" },
      }

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        desc = "Lint modifiable buffers only",
        group = lint_augroup,
        callback = function()
          if vim.opt_local.modifiable:get() then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
