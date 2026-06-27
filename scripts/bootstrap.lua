-- Headless bootstrap helper invoked by install.sh.
-- Installs Mason tools (incl. the tree-sitter CLI), then compiles the
-- Treesitter parsers, blocking until everything is finished.

-- Ensure the Mason-installed `tree-sitter` CLI is on PATH for parser builds.
vim.env.PATH = vim.fn.stdpath('data') .. '/mason/bin:' .. vim.env.PATH
local ts_bin = vim.fn.stdpath('data') .. '/mason/bin/tree-sitter'

-- Trigger Mason tool installation. We mainly need the tree-sitter CLI before
-- compiling parsers, so wait until that binary exists (fast if already there).
-- (Don't block on the completion event: it may not fire when nothing needs
-- installing. Any remaining LSP servers finish in the background / next launch.)
local completed = false
vim.api.nvim_create_autocmd('User', {
  pattern = 'MasonToolsUpdateCompleted',
  callback = function() completed = true end,
})
pcall(vim.cmd, 'MasonToolsInstall')
vim.wait(300000, function() return vim.fn.executable(ts_bin) == 1 end, 300)
-- Give other tools a short grace period to finish too (best-effort).
vim.wait(20000, function() return completed end, 300)

-- Compile parsers, blocking until done (install() returns an awaitable task).
local parsers = require('config.treesitter_parsers')
local ok, err = pcall(function()
  require('nvim-treesitter').install(parsers):wait(600000)
end)
if not ok then
  io.stderr:write('parser install error: ' .. tostring(err) .. '\n')
end

vim.cmd('qa!')
