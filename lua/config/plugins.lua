-- Plugin installation and configuration
-- Uses Neovim's built-in plugin manager `vim.pack` (see `:h vim.pack`).
-- Versions are pinned in nvim-pack-lock.json so installs are reproducible.

-- Disable search highlight automatically after a moment / on insert
vim.cmd('packadd! nohlsearch')

vim.pack.add({
  -- LSP configs (provides server defaults consumed by vim.lsp.enable)
  'https://github.com/neovim/nvim-lspconfig',

  -- Install LSP servers / formatters / linters from inside Neovim
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

  -- Syntax highlighting & more (Treesitter). Pinned to the `main` branch,
  -- which is the one compatible with Neovim 0.11+. Parsers are built with the
  -- `tree-sitter` CLI (installed via Mason above).
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

  -- Formatting (Prettier / Prettierd, etc.)
  'https://github.com/stevearc/conform.nvim',

  -- Fuzzy finder
  'https://github.com/ibhagwan/fzf-lua',

  -- Autocompletion
  'https://github.com/nvim-mini/mini.completion',

  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',

  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',

  -- File explorer sidebar (VS Code-like tree)
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-neo-tree/neo-tree.nvim',

  -- Integrated terminal (toggleable, like VS Code's panel)
  'https://github.com/akinsho/toggleterm.nvim',

  -- A pleasant colorscheme
  'https://github.com/catppuccin/nvim',

  -- Custom start screen / dashboard
  'https://github.com/goolord/alpha-nvim',
})

-- ---------------------------------------------------------------------------
-- Colorscheme
-- ---------------------------------------------------------------------------
require('catppuccin').setup({
  flavour = 'mocha',
  term_colors = true, -- give the built-in terminal a readable ANSI palette
})
vim.cmd.colorscheme('catppuccin')

-- ---------------------------------------------------------------------------
-- Start screen (alpha-nvim) — custom "J" splash instead of the default N logo
-- ---------------------------------------------------------------------------
local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = {
  [[                                         ]],
  [[              ██╗     ██╗                ]],
  [[              ██║    ███║                ]],
  [[              ██║    ╚██║                ]],
  [[         ██╗  ██║     ██║                ]],
  [[         ╚█████╔╝     ██║                ]],
  [[          ╚════╝      ╚═╝                ]],
  [[                                         ]],
  [[            n e o v i m                  ]],
}

dashboard.section.buttons.val = {
  dashboard.button('f', '  Find file', '<cmd>FzfLua files<CR>'),
  dashboard.button('g', '  Live grep', '<cmd>FzfLua live_grep<CR>'),
  dashboard.button('r', '  Recent files', '<cmd>FzfLua oldfiles<CR>'),
  dashboard.button('e', '  New file', '<cmd>ene | startinsert<CR>'),
  dashboard.button('c', '  Config', '<cmd>edit $MYVIMRC<CR>'),
  dashboard.button('q', '  Quit', '<cmd>qa<CR>'),
}

dashboard.section.footer.val = 'good morning, juan'

alpha.setup(dashboard.config)

-- ---------------------------------------------------------------------------
-- Mason: tool manager + auto-install our toolchain
-- ---------------------------------------------------------------------------
require('mason').setup()
require('mason-tool-installer').setup({
  ensure_installed = {
    -- LSP servers
    'typescript-language-server', -- ts_ls
    'eslint-lsp',                 -- eslint
    'json-lsp',                   -- jsonls
    'lua-language-server',        -- lua_ls (for editing this config)
    -- Formatters
    'prettierd',
    'prettier',
    'stylua',
    -- Treesitter parser compiler (used by nvim-treesitter `main` branch)
    'tree-sitter-cli',
  },
})

-- ---------------------------------------------------------------------------
-- LSP (Neovim 0.11+ native API: vim.lsp.config / vim.lsp.enable)
-- nvim-lspconfig ships the per-server defaults under its `lsp/` directory.
-- ---------------------------------------------------------------------------

-- Diagnostics appearance
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  severity_sort = true,
  float = { border = 'rounded', source = true },
})

-- Per-buffer LSP keymaps, attached only when a server is active.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP keymaps',
  callback = function(args)
    local buf = args.buf
    local function bmap(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = buf, desc = 'LSP: ' .. desc })
    end

    bmap('grn', vim.lsp.buf.rename, 'Rename symbol')
    bmap('gra', vim.lsp.buf.code_action, 'Code action')
    bmap('grr', '<cmd>FzfLua lsp_references<CR>', 'References')
    bmap('grd', '<cmd>FzfLua lsp_definitions<CR>', 'Go to definition')
    bmap('gri', '<cmd>FzfLua lsp_implementations<CR>', 'Go to implementation')
    bmap('grt', '<cmd>FzfLua lsp_typedefs<CR>', 'Go to type definition')
    bmap('gO', '<cmd>FzfLua lsp_document_symbols<CR>', 'Document symbols')
    bmap('K', vim.lsp.buf.hover, 'Hover docs')
    bmap('<leader>D', vim.lsp.buf.declaration, 'Go to declaration')

    -- Inlay hints toggle (if the server supports it)
    if vim.lsp.inlay_hint then
      bmap('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
      end, 'Toggle inlay hints')
    end
  end,
})

-- Enable the servers (configs come from nvim-lspconfig). Tools are installed by Mason above.
vim.lsp.enable({ 'ts_ls', 'eslint', 'jsonls', 'lua_ls' })

-- ---------------------------------------------------------------------------
-- Treesitter (better syntax highlighting, indentation, etc.) — `main` branch API
-- ---------------------------------------------------------------------------
local ts_parsers = {
  'typescript', 'javascript', 'tsx', 'json',
  'lua', 'vim', 'vimdoc', 'bash', 'markdown', 'markdown_inline',
  'html', 'css', 'yaml', 'toml', 'dockerfile', 'sql', 'gitcommit',
}

-- Install/compile parsers (async, no-op if already installed). Needs `tree-sitter`.
pcall(function()
  require('nvim-treesitter').install(ts_parsers)
end)

-- Start Treesitter highlighting (+ indentation) whenever a buffer's filetype is set.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Enable Treesitter highlighting',
  callback = function(args)
    -- Only start if a parser is available for this language.
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.language.add(lang) then
      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- ---------------------------------------------------------------------------
-- Formatting (conform.nvim) — format on save with Prettier for web/TS files
-- ---------------------------------------------------------------------------
require('conform').setup({
  formatters_by_ft = {
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier', stop_after_first = true },
    jsonc = { 'prettierd', 'prettier', stop_after_first = true },
    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    html = { 'prettierd', 'prettier', stop_after_first = true },
    css = { 'prettierd', 'prettier', stop_after_first = true },
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
    lua = { 'stylua' },
  },
  format_on_save = function(bufnr)
    -- Allow disabling via :FormatDisable (see command below)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return { timeout_ms = 1000, lsp_format = 'fallback' }
  end,
})

vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer/selection' })

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true -- buffer-local
  else
    vim.g.disable_autoformat = true -- global
  end
end, { desc = 'Disable autoformat-on-save', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = 'Re-enable autoformat-on-save' })

-- ---------------------------------------------------------------------------
-- Fuzzy finder (fzf-lua) + keymaps
-- ---------------------------------------------------------------------------
require('fzf-lua').setup({ fzf_colors = true })

local fzf = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', fzf.live_grep, { desc = 'Live grep (project search)' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Find help' })
vim.keymap.set('n', '<leader>fr', fzf.resume, { desc = 'Resume last picker' })
vim.keymap.set('n', '<leader>fd', fzf.diagnostics_document, { desc = 'Document diagnostics' })
vim.keymap.set('n', '<leader>/', fzf.blines, { desc = 'Search in current buffer' })
vim.keymap.set('n', '<leader><leader>', fzf.files, { desc = 'Find files (quick)' })

-- ---------------------------------------------------------------------------
-- Completion (mini.completion) — LSP-aware autocomplete
-- ---------------------------------------------------------------------------
require('mini.completion').setup({})

-- ---------------------------------------------------------------------------
-- Quickfix improvements
-- ---------------------------------------------------------------------------
require('quicker').setup({})

-- ---------------------------------------------------------------------------
-- Git signs in the gutter + hunk navigation
-- ---------------------------------------------------------------------------
require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local function gmap(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = bufnr, desc = 'Git: ' .. desc })
    end
    gmap('n', ']c', function() gs.nav_hunk('next') end, 'Next hunk')
    gmap('n', '[c', function() gs.nav_hunk('prev') end, 'Prev hunk')
    gmap('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
    gmap('n', '<leader>gr', gs.reset_hunk, 'Reset hunk')
    gmap('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
    gmap('n', '<leader>gb', function() gs.blame_line({ full = true }) end, 'Blame line')
  end,
})

-- ---------------------------------------------------------------------------
-- File explorer (neo-tree) — VS Code-like sidebar, opens on the RIGHT
-- ---------------------------------------------------------------------------
require('neo-tree').setup({
  close_if_last_window = true, -- close Neovim if neo-tree is the last window
  window = {
    position = 'right',
    width = 34,
    mappings = {
      ['<space>'] = 'none', -- don't hijack leader inside the tree
    },
  },
  filesystem = {
    follow_current_file = { enabled = true }, -- highlight the file you're editing
    use_libuv_file_watcher = true,            -- auto-refresh on external changes
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = false,
    },
  },
})

-- Toggle the tree (like VS Code's Ctrl-B). Also reveal current file.
vim.keymap.set('n', '<C-n>', '<cmd>Neotree toggle right<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>n', '<cmd>Neotree toggle right<CR>', { desc = 'Toggle file explorer' })
vim.keymap.set('n', '<leader>o', '<cmd>Neotree focus right<CR>', { desc = 'Focus file explorer' })
vim.keymap.set('n', '<leader>R', '<cmd>Neotree reveal right<CR>', { desc = 'Reveal current file in tree' })

-- ---------------------------------------------------------------------------
-- Integrated terminal (toggleterm) — VS Code-style toggleable terminal
-- ---------------------------------------------------------------------------
require('toggleterm').setup({
  open_mapping = [[<C-\>]], -- Ctrl-\ toggles the terminal in normal/insert/terminal mode
  direction = 'horizontal', -- 'horizontal' | 'vertical' | 'float' | 'tab'
  dir = 'git_dir',          -- open in the git project root of the current file
                            -- (falls back to the current working directory)
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return math.floor(vim.o.columns * 0.4)
    end
  end,
  start_in_insert = true,
  persist_size = true,
  persist_mode = true,
  float_opts = { border = 'rounded' },
})

-- Extra ways to open the terminal in specific layouts
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Terminal: float' })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', { desc = 'Terminal: vertical split' })
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm direction=tab<CR>', { desc = 'Terminal: new tab' })

-- While inside a terminal, jump to other windows with <A-h/j/k/l> (set in keymaps.lua)
-- and exit terminal mode with <Esc>.
