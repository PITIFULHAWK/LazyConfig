return {
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       -- Flutter and Dart LSP configuration
  --       settings = {
  --         dart = {
  --           completeFunctionCalls = true,
  --           showTodos = true,
  --           enableSnippets = true,
  --           updateImportsOnRename = true,
  --         },
  --       },
  --     },
  --   },
  -- },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "dart-debug-adapter",
      })
    end,
  },
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      lsp = {
        color = {
          enabled = true,
          background = true,
          virtual_text = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          enableSnippets = true,
        },
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
      },
      widget_guides = {
        enabled = true,
      },
      dev_log = {
        enabled = true,
        open_cmd = "tabedit", -- command to use to open the log buffer
      },
      ui = {
        -- the border type to use for all floating windows, the same options passed to nvim_open_win
        border = "rounded",
        notification_style = "plugin",
      },
      decorations = {
        statusline = {
          -- set to true to be able to use 'flutter_tools_decorations.app_version' in your statusline
          app_version = true,
          -- set to true to be able to use 'flutter_tools_decorations.device' in your statusline
          device = true,
        },
      },
      flutter_path = "flutter", -- this assumes flutter is in your PATH
      closing_tags = {
        highlight = "ErrorMsg",
        prefix = "//",
        enabled = true,
      },
    },
    keys = {
      { "<leader>Fc", "<cmd>FlutterCopyProfilerUrl<cr>", desc = "Copy Profile Url" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "List Devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "List Emulators" },
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Run" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Quit" },
      { "<leader>Fr", "<cmd>FlutterReload<cr>", desc = "Reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Restart" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Toggle Outline" },
    },
  },
  -- Add Treesitter support for Dart
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "dart",
      })
    end,
  },
  -- Add dart-vim-plugin for improved Dart syntax highlighting
  {
    "dart-lang/dart-vim-plugin",
    lazy = false,
    ft = "dart",
  },
}
