return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    keys = {
      -- files / working
      { "<leader>gs", "<cmd>Git<CR>", desc = "[G]it [S]tatus" },
      { "<leader>ga", "<cmd>Gwrite<CR>", desc = "[G]it [A]dd current file" },
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "[G]it [C]ommit" },
      { "<leader>gC", "<cmd>Git commit -a<CR>", desc = "[G]it [C]ommit with add" },
      { "<leader>gm", "<cmd>Git commit --amend --no-edit<CR>", desc = "[G]it a[M]end last commit" },
      { "<leader>gp", "<cmd>Git push<CR>", desc = "[G]it [P]ush" },
      {
        "<leader>gt",
        function()
          local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
          vim.cmd("Git push -u origin " .. branch)
        end,
        desc = "[G]it push set upstream [T]arget",
      },
      { "<leader>gP", "<cmd>Git pull --rebase --autostash<CR>", desc = "[G]it [P]ull rebase autostash" },
      { "<leader>gr", "<cmd>Git reset HEAD %<CR>", desc = "[G]it [R]eset current file" },
      { "<leader>gu", "<cmd>Gedit<CR>", desc = "[G]it [U]ndo buffer to HEAD" },

      -- diff
      { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "[G]it [D]iff" },
      { "<leader>gD", "<cmd>Gdiffsplit --cached<CR>", desc = "[G]it staged [D]iff" },
      { "<leader>g<", "<cmd>diffget //2<CR>", desc = "[G]it diffget from index (ours)" },
      { "<leader>g>", "<cmd>diffget //3<CR>", desc = "[G]it diffget from working (theirs)" },

      -- branches
      { "<leader>gf", "<cmd>Git fetch --prune<CR>", desc = "[G]it [F]etch" },
      { "<leader>gb", "<cmd>Git branch<CR>", desc = "[G]it [B]ranches" },
      { "<leader>gB", "<cmd>Git branch -a<CR>", desc = "[G]it all [B]ranches" },
      {
        "<leader>gw",
        function()
          local branch = vim.fn.input("Switch to branch: ")
          vim.cmd("Git switch " .. branch)
        end,
        desc = "[G]it s[W]itch branch",
      },
      {
        "<leader>gW",
        function()
          local branch = vim.fn.input("Switch to new branch: ")
          if branch ~= "" then
            vim.cmd("Git switch -c " .. branch)
          else
            vim.notify("Provide a new branch name", vim.log.levels.WARN)
          end
        end,
        desc = "[G]it s[W]itch new branch",
      },

      -- history
      { "<leader>gl", "<cmd>Git log --oneline --graph --decorate<CR>", desc = "[G]it [L]og graph" },
      { "<leader>ge", "<cmd>Git blame<CR>", desc = "[G]it blam[E] / [E]dits" },
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
        end, { desc = "Jump to next git [c]hange" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Jump to previous git [c]hange" })

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [H]unk [S]tage" })
        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "git [H]unk [R]eset" })

        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [H]unk toggle [S]tage" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [H]unk [R]eset" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [H]unk [P]review" })
        map("n", "<leader>he", gitsigns.blame_line, { desc = "git [H]unk blam[E] line" }) -- consistent with fugitive
        map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [H]unk [D]iff against index" })
        map("n", "<leader>hD", function()
          gitsigns.diffthis("@")
        end, { desc = "git [H]unk [D]iff against last commit" })
      end,
    },
  },
}
