return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters.clangtidy.args = { "-std=c17", "-std=c++20", "--" }
      lint.linters.luacheck.args = { "--globals", "vim", "--" }
      lint.linters_by_ft = {
        -- core
        c = { "clangtidy" },
        cpp = { "clangtidy" },
        rust = { "clippy" },
        go = { "golangci_lint" },
        -- python via ruff lsp
        -- web
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        html = { "htmlhint" },
        css = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
        -- other
        lua = { "luacheck" },
        sh = { "shellcheck" },
        markdown = { "markdownlint-cli2" },
        json = { "jsonlint" },
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
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
