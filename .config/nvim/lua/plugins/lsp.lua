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

          -- conform owns formatting; keep biome out of the LSP format-fallback path
          if client and client.name == "biome" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
          -- defer hover to the type checker
          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

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
        -- core
        clangd = {
          cmd = { "clangd", "--clang-tidy" },
          init_options = {
            fallbackFlags = { "-std=c23", "-std=c++23" },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
            },
          },
        },
        gopls = {},
        pyrefly = {},
        ruff = {},
        -- web
        tsgo = {},
        biome = {
          -- attach without requiring a project biome.json
          workspace_required = false,
          root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, { ".git", "package.json", "biome.json", "biome.jsonc" }) or vim.fn.getcwd())
          end,
        },
        html = {},
        cssls = {},
        -- other
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
        dockerls = {},
        taplo = {},
        marksman = {},
      }

      local server_names = vim.tbl_keys(servers)

      vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      local ensure_installed = vim.list_extend(vim.deepcopy(server_names), {
        -- formatters --
        "clang-format",
        -- rustfmt via rustup
        "goimports",
        "stylua",
        "shfmt",
        "markdownlint-cli2",
        "yamlfmt",
        "xmlformatter",

        -- linters --
        -- clang-tidy via clangd
        -- clippy via rust_analyzer
        "golangci-lint",
        "shellcheck", -- consumed by bashls
        "yamllint",
        "hadolint",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {}, -- installed via mason-tool-installer
        automatic_enable = server_names,
      })
    end,
  },
}
