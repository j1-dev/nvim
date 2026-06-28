-- Keymaps
-- See `:h vim.keymap.set()`. Leader key is <space> (set in init.lua).

local map = vim.keymap.set

-- Clear search highlight with <Esc>
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode with <Esc>
map('t', '<Esc>', '<C-\\><C-n>')

-- Window navigation with Ctrl + h/j/k/l (works in normal, insert, terminal)
map({ 't', 'i' }, '<C-h>', '<C-\\><C-n><C-w>h')
map({ 't', 'i' }, '<C-j>', '<C-\\><C-n><C-w>j')
map({ 't', 'i' }, '<C-k>', '<C-\\><C-n><C-w>k')
map({ 't', 'i' }, '<C-l>', '<C-\\><C-n><C-w>l')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Save / quit shortcuts
map('n', '<leader>w', '<cmd>write<CR>', { desc = 'Write/save file' })
map('n', '<leader>q', '<cmd>quit<CR>', { desc = 'Quit window' })

-- Move selected lines up/down in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Keep cursor centered when jumping half-pages / through search results
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- Diagnostics
map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic in float' })
map('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Diagnostics to loclist' })
