return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      "b0o/schemastore.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- aligned with 0.11+ lsp keymaps:
          map("grd", vim.lsp.buf.definition, "[G]oto [R]efactor [D]efinition")
          map("grD", vim.lsp.buf.declaration, "[G]oto [R]efactor [D]eclaration")
          -- gri
          -- grt
          -- grr
          -- gO
          -- i_CTRL-S
          -- gra
          -- grn
          -- grx

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle [C]ode Inlay [H]ints")
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspProgress", {
        group = vim.api.nvim_create_augroup("lsp-progress", { clear = true }),
        callback = function(ev)
          local value = ev.data.params.value
          local echo_id = "lsp." .. ev.data.params.token

          vim.api.nvim_echo({ { value.message or "done" } }, false, {
            id = echo_id,
            kind = "progress",
            source = "vim.lsp",
            title = value.title,
            status = value.kind ~= "end" and "running" or "success",
            percent = value.percentage,
          })

          if value.kind == "end" then
            vim.defer_fn(function()
              vim.api.nvim_echo({ { "" } }, false, {
                id = echo_id,
              })
            end, 2000)
          end
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = { min = vim.diagnostic.severity.ERROR } },
        signs = {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
        },
        -- Auto open the float when jumping with `[d` and `]d`
        jump = {
          on_jump = function(_, bufnr)
            vim.diagnostic.open_float({
              bufnr = bufnr,
              scope = "cursor",
              focus = false,
            })
          end,
        },
      })

      local servers = {
        clangd = {
          init_options = {
            fallbackFlags = { "-std=c23", "-std=c++23" },
          },
        },
        neocmake = {},
        -- rust-analyzer is managed by rustaceanvim
        gopls = {},
        pyrefly = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = { disable = { "missing-fields" } },
            },
          },
        },
        bashls = {},
        tsc = {},
        html = {},
        cssls = {},
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemas = require("schemastore").yaml.schemas(),
              validate = true,
            },
          },
        },
        buf_ls = {},
        tombi = {},
        docker_language_server = {
          init_options = {
            telemetry = "off",
          },
        },
        tofu_ls = {},
        marksman = {},
      }

      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      local server_names = vim.tbl_keys(servers)
      vim.lsp.enable(server_names) -- enable all servers

      require("mason-lspconfig").setup({
        ensure_installed = {}, -- installed via mason-tool-installer
        automatic_enable = false,
      })

      -- exclude system installs from mason installer
      local excluded = { clangd = true, buf_ls = true, tombi = true }
      local mason_servers = vim.tbl_filter(function(server)
        return not excluded[server]
      end, server_names)
      require("mason-tool-installer").setup({ ensure_installed = mason_servers })
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
            },
          },
        },
      }
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        -- "Only load luvit types when the `vim.uv` word is found"
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
