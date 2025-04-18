-- Snacks animations
-- Set to `false` to globally disable all snacks animations
vim.g.snacks_animate = true

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.wrap = true -- Disable line wrap
