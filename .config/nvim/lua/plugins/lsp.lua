return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },

      "hrsh7th/cmp-nvim-lsp",

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

          -- accept 0.11 lsp keymaps, others updated to align:
          map("grd", vim.lsp.buf.definition, "[G]oto [R]efactor [D]efinition")
          map("grD", vim.lsp.buf.declaration, "[G]oto [R]efactor [D]eclaration")
          -- gri
          map("grt", vim.lsp.buf.type_definition, "[G]oto [R]efactor [T]ype definition")
          -- grr
          -- gO
          -- i_CTRL-S
          -- gra
          -- grn

          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            return client:supports_method(method, bufnr)
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
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

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle [C]ode Inlay [H]ints")
          end
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
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
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
            },
          },
        },
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
        tofu_ls = {
          filetypes = { "terraform", "terraform-vars" },
        },
        marksman = {},
      }

      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
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
      local excluded = { clangd = true, rust_analyzer = true, buf_ls = true, tombi = true }
      local mason_servers = vim.tbl_filter(function(server)
        return not excluded[server]
      end, server_names)
      require("mason-tool-installer").setup({ ensure_installed = mason_servers })
    end,
  },
}
