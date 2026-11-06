return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    keys = {
      { "<leader>gs", "<cmd>Git<CR>", desc = "[G]it [S]ummary" },
      {
        "<leader>gb",
        function()
          require("fzf-lua").git_branches()
        end,
        desc = "[G]it [B]ranches",
      },
      {
        "<leader>gl",
        function()
          require("fzf-lua").git_bcommits()
        end,
        desc = "[G]it buffer [L]og",
      },
      {
        "<leader>gL",
        function()
          require("fzf-lua").git_commits()
        end,
        desc = "[G]it [L]og",
      },
      { "<leader>ga", "<cmd>Git blame<CR>", desc = "[G]it [A]nnotate (blame)" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, { desc = "Jump to next [C]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Jump to previous [C]hange" })

        map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Select [I]nside git [H]unk" })

        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [H]unk [P]review" })

        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [H]unk [S]tage toggle" })
        map("x", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [H]unk [S]tage" })

        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [H]unk [R]eset" })
        map("x", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [H]unk [R]eset" })

        map("n", "<leader>ha", function()
          gitsigns.blame_line({ full = true })
        end, { desc = "git [H]unk [A]nnotate (blame)" })
      end,
    },
  },
}
