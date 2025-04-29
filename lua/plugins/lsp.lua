-- stylua: ignore
return {
  {
    "neovim/nvim-lspconfig",
    -- still have our CursorHold hover & updatetime tweak
    -- init = function()
    --   vim.o.updatetime = 250
    --   vim.api.nvim_create_augroup("_CursorDiagnostics", { clear = true })
    --   vim.api.nvim_create_autocmd("CursorHold", {
    --     group    = "_CursorDiagnostics",
    --     pattern  = "*",
    --     callback = function()
    --       vim.diagnostic.open_float(nil, { focusable = false })
    --     end,
    --   })
    -- end,

    -- pull in typescript.nvim and SchemaStore support
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      "b0o/SchemaStore.nvim",
    },

    opts = function()
      local lspconfig = require("lspconfig")
      local base_caps = vim.lsp.protocol.make_client_capabilities()

      -- augment with blink.cmp capabilities if available
      if pcall(require, "blink.cmp") then
        base_caps = require("blink.cmp").get_lsp_capabilities(base_caps)
      end

      -- final LSP config table
      local ret = {
        -- diagnostics, inlay hints, codelens & formatting
        diagnostics = {
          underline        = true,
          update_in_insert = false,
          virtual_text     = {
            spacing = 4,
            source  = "if_many",
            prefix  = "●",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN]  = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.INFO]  = LazyVim.config.icons.diagnostics.Info,
              [vim.diagnostic.severity.HINT]  = LazyVim.config.icons.diagnostics.Hint,
            },
          },
        },
        inlay_hints = { enabled = true, exclude = { "vue" } },
        codelens    = { enabled = false },
        capabilities = base_caps,
        format = { formatting_options = nil, timeout_ms = nil },

        -- 1) Per‑server settings
        servers = {
          -- Lua: disable telemetry & enable codelens
          lua_ls = {
            settings = {
              Lua = {
                workspace    = { checkThirdParty = false },
                codeLens     = { enable = true },
                completion   = { callSnippet = "Replace" },
                hint         = { enable = true },
                telemetry    = { enable = false },
              },
            },
          },

          -- Webdev: JS/TS + React & Node
          tsserver    = {}, -- handled in setup()
          eslint      = {},

          -- HTML/CSS/JSON/Tailwind/Emmet
          html = { init_options = { provideFormatter = true } },
          cssls = {
            settings = {
              css = { validate = true },
              scss = { validate = true },
              less = { validate = true },
            },
          },
          jsonls = {},        -- handled in setup()
          tailwindcss = {     -- tailwind config detection
            filetypes = {
              "html", "css", "javascript", "javascriptreact",
              "typescript", "typescriptreact", "svelte", "vue"
            },
            init_options = { userLanguages = { eelixir = "html-eex" } },
          },
          emmet_ls = {
            filetypes = {
              "html", "css", "javascript", "javascriptreact",
              "typescriptreact", "sass", "scss", "less"
            },
            init_options = {
              html = { options = { ["bem.enabled"] = true } },
            },
          },

          -- Python
          pyright = {
            settings = {
              python = {
                analysis = {
                  typeCheckingMode = "basic",
                  autoSearchPaths  = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                  extraPaths = { "." }, -- Helps find local packages
                },
                venvPath = ".",      -- <- This tells Pyright where to find `.venv`
                venv = ".venv",      -- <- Optional: preferred environment folder name
              },
            },
          },

          -- C / C++
          clangd = {
            cmd = { "clangd", "--background-index", "--clang-tidy" },
          },

          -- Rust (no rust-tools here; plain rust_analyzer)
          rust_analyzer = {
            settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                checkOnSave = { command = "clippy" },
              },
            },
          },

          -- Java (jdtls uses default launcher & workspace)
          jdtls = {},
        },

        -- 2) Per‑server overrides
        setup = {
          -- tsserver via typescript.nvim
          tsserver = function(_, opts)
            require("typescript").setup({ server = opts })
            return true
          end,
          -- jsonls + SchemaStore
          jsonls = function(_, opts)
            local schemas = require("schemastore").json.schemas()
            lspconfig.jsonls.setup(vim.tbl_deep_extend("force", opts, {
              settings = { json = { schemas = schemas, validate = { enable = true } } },
            }))
            return true
          end,
        },
      }

      return ret
    end,
  },
  {
    "mason.nvim",
    { "williamboman/mason-lspconfig.nvim", config = function() end },
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "clangd",
        "css-lsp",
        "emmet-ls",
        "eslint-lsp",
        "html-lsp",
        "jdtls",
        "json-lsp",
        "lua-language-server",
        "pyright",
        "rust-analyzer",
        "tailwindcss-language-server",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  }
}
