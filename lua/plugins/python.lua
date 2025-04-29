-- Example LSP config in your `init.lua`
return {
  require("lspconfig").pyright.setup({
    settings = {
      python = {
        pythonPath = ".venv/bin/python", -- Adjust path if needed
      },
    },
  }),
}
