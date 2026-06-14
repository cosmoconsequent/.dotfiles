return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      -- c/cpp via clangd (--clang-tidy); rust via rust_analyzer (clippy);
      -- python/js/ts/css/json via LSP; lua via lua_ls; sh via bashls (shellcheck)
      lint.linters_by_ft = {
        go = { "golangcilint" },
        markdown = { "markdownlint-cli2" },
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
