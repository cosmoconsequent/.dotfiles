return {
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          layout_strategy = "vertical",
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")

      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
      vim.keymap.set("n", "<leader>fG", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "[F]ind by [G]rep base string" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind in existing [B]uffers" })
      vim.keymap.set("n", "<leader>fs", builtin.git_files, { desc = "[F]ind by git [S]ource" })

      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
      vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
      vim.keymap.set("n", "<leader>fp", builtin.builtin, { desc = "[F]ind Telescope [P]ickers" })

      vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind current [W]ord" })
      vim.keymap.set("n", "<leader>fW", function()
        builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
      end, { desc = "[F]ind current [W]ORD)" })

      vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })

      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
      vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })

      vim.keymap.set("n", "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 20,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      vim.keymap.set("n", "<leader>f/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[F]ind [/] in Open Files" })

      vim.keymap.set("n", "<leader>fn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[F]ind in [N]eovim files" })
    end,
  },

  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>fc",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "[F]ind and [C]hange in project files",
      },
    },
  },
}
