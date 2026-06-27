-- ~/.config/nvim/init.lua
-- Entry point. Real config lives in lua/config/*.lua
--
-- Layout:
--   lua/config/options.lua   editor settings
--   lua/config/keymaps.lua   key mappings
--   lua/config/autocmds.lua  autocommands + custom commands
--   lua/config/plugins.lua   plugins (vim.pack) + LSP/TS tooling

-- Leader key MUST be set before plugins load. See `:h mapleader`.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.plugins')
