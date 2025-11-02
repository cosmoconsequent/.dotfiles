local formatters_by_ft = {
  -- core
  c = { "clang-format" },
  cpp = { "clang-format" },
  rust = { "rustfmt" },
  go = { "goimports" },
  python = { "ruff" },
  -- web
  javascript = { "prettierd", "prettier", stop_after_first = true },
  typescript = { "prettierd", "prettier", stop_after_first = true },
  javascriptreact = { "prettierd", "prettier", stop_after_first = true },
  typescriptreact = { "prettierd", "prettier", stop_after_first = true },
  html = { "prettierd", "prettier", stop_after_first = true },
  css = { "prettierd", "prettier", stop_after_first = true },
  scss = { "prettierd", "prettier", stop_after_first = true },
  less = { "prettierd", "prettier", stop_after_first = true },
  -- other
  lua = { "stylua" },
  sh = { "shfmt" },
  markdown = { "markdownlint-cli2" },
  json = { "prettierd", "prettier", stop_after_first = true },
  xml = { "xmlformatter" },
  yaml = { "prettierd", "prettier", stop_after_first = true },
}

-- only LSP format when there's no dedicated formatter
local lsp_fallback = function(bufnr)
  local ft = vim.bo[bufnr].filetype
  local formatters = formatters_by_ft[ft]

  if formatters and #formatters > 0 then
    return false
  end

  return true
end

return {
  "tpope/vim-sleuth",

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>=",
        function()
          local bufnr = vim.api.nvim_get_current_buf()
          local fallback = lsp_fallback(bufnr)

          require("conform").format({
            async = true,
            lsp_format = fallback and "fallback" or "never",
          })
        end,
        mode = "",
        desc = "[=] format buffer",
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        return { timeout = 500, lsp_fallback = lsp_fallback(bufnr) }
      end,
      formatters_by_ft = formatters_by_ft,
      formatters = {
        stylua = {
          prepend_args = {
            "--indent-type",
            "Spaces",
            "--indent-width",
            "2",
          },
        },
      },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
  },
}
