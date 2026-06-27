-- Autocommands and custom user commands
-- See `:h lua-guide-autocommands`

-- Highlight yanked (copied) text briefly. Try `yap`.
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Remove trailing whitespace on save (kept simple; formatting is handled by conform)
vim.api.nvim_create_autocmd('BufWritePre', {
  desc = 'Trim trailing whitespace',
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- :GitBlameLine -> print git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.')
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })
