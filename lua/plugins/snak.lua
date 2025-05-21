return {
  "folke/snacks.nvim",
  -- make sure this loads early so the opts take effect immediately
  priority = 1000,
  lazy = false,

  opts = {
    explorer = {
      supports_live = true,
      tree = true,
      watch = true,
      diagnostics_open = false,
      git_status_open = true,
      auto_close = false,
      jump = { close = false },

      -- <<< This makes the **explorer tree** show dotfiles by default
      hidden = true,

      -- force the scanner to include hidden files
      command = {
        bin = "fd",
        args = { "-H", "-t", "f" },
      },

      matcher = {
        sort_empty = true,
        fuzzy = true,
        show_hidden = true, -- also allow the matcher to pass hidden files through
        filter = function(_)
          return true
        end,
      },

      formatters = {
        file = { filename_only = true },
        severity = { pos = "right" },
      },

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
      -- ensure the **explorer picker** also starts with hidden = true
      sources = {
        explorer = {
          hidden = true, -- <<< here, so Snacks.picker.explorer honors dotfiles
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
      "<leader>n",
      function()
        require("snacks").explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
}
