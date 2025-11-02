return {
  {
    "rebelot/kanagawa.nvim",
    priority = 1000, -- "Make sure to load this before all the other start plugins"
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("kanagawa").setup({
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        statementStyle = { bold = false },
        colors = {
          theme = { wave = { ui = { bg = "#181818" } }, all = { ui = { bg_gutter = "none" } } },
        },
        overrides = function(colors)
          local theme = colors.theme
          return {
            Boolean = { bold = false },
            Comment = { fg = "#8E8E93" }, -- fujiGray is tough to read, replaced with Apple system gray
            Visual = { bg = colors.palette.waveBlue1 },
            TelescopeTitle = { fg = theme.ui.special, bold = true },
            TelescopePromptNormal = { bg = theme.ui.bg_p1 },
            TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
            TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
            TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
            TelescopePreviewNormal = { bg = theme.ui.bg_dim },
            TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}
