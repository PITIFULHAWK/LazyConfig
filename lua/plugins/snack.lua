return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      supports_live = true,
      tree = true,
      watch = true,
      diagnostics_open = false,
      git_status_open = false,
      follow_file = true,
      auto_close = false,
      jump = { close = false },
      formatters = {
        file = { filename_only = true },
        severity = { pos = "right" },
      },
      matcher = { sort_empty = false, fuzzy = true },
      win = {
        list = {
          keys = {
            ["<c-c>"] = {},
            ["."] = {},
          },
        },
      },
    },
    picker = {
      sources = {
        explorer = {
          layout = {
            layout = { position = "right" },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>e",
      function()
        require("snacks").explorer({ cwd = require("lazyvim.util").root() })
      end,
      desc = "Explorer Snacks (root dir)",
    },
    {
      "<leader>E",
      function()
        require("snacks").explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
  },
}
