local excluded = {
  diff = true,
  gitsendemail = true,
}

local formatters_by_ft = {
  c = { "clang-format" },
  cpp = { "clang-format" },
  cmake = { "gersemi" },
  rust = { "rustfmt" },
  go = { "goimports" },
  python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
  lua = { "stylua" },
  sh = { "shfmt" },
  javascript = { "biome-check" },
  typescript = { "biome-check" },
  javascriptreact = { "biome-check" },
  typescriptreact = { "biome-check" },
  html = { lsp_format = "prefer" },
  css = { "biome-check" },
  json = { "biome-check" },
  jsonc = { "biome-check" },
  yaml = { "yamlfmt" },
  proto = { "buf" },
  toml = { "tombi" },
  dockerfile = { "dockerfmt" },
  terraform = { "tofu_fmt" },
  ["terraform-vars"] = { "tofu_fmt" },
  markdown = { "markdownlint-cli2" },
  ["_"] = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if excluded[ft] then
      return {}
    end

    return { "trim_whitespace", "trim_newlines" }
  end,
}

return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>=",
        function()
          require("conform").format({
            async = true,
          })
        end,
        mode = { "n", "x" },
        desc = "[=] format buffer",
      },
    },
    opts = {
      notify_on_error = true,
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 500,
      },
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
        -- 2-space indent for config-less projects; a project biome.json overrides
        ["biome-check"] = {
          args = function(_, ctx)
            local args = { "check", "--write", "--stdin-file-path", ctx.filename }
            if not vim.fs.root(ctx.filename, { "biome.json", "biome.jsonc" }) then
              table.insert(args, 2, "--indent-style=space")
            end
            return args
          end,
        },
      },
    },
  },
}
