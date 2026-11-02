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
            Comment = { fg = "#8E8E93" }, -- fujiGray is difficult to read, replaced with Apple system gray
            Visual = { bg = colors.palette.waveBlue1 },
          }
        end,
      })
      vim.cmd.colorscheme("kanagawa-wave")
    end,
  },
}
