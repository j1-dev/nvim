# nvim-ide

My personal Neovim configuration — a lightweight TypeScript / backend IDE.

Built on **Neovim 0.12+** using the built-in `vim.pack` plugin manager (no
external bootstrap needed). Language servers, formatters and Treesitter parsers
auto-install on first launch.

## Features

- **LSP** for TypeScript/JavaScript (`ts_ls`), ESLint, JSON, and Lua
- **Autocompletion** via `mini.completion` (LSP-aware)
- **Treesitter** syntax highlighting & indentation
- **Formatting** with Prettier (`prettierd`/`prettier`) — format on save
- **Fuzzy finding** with `fzf-lua`
- **Git** signs + hunk actions via `gitsigns`
- **Mason** auto-installs all tooling, **pinned plugin versions** via lock file

## Requirements

On any machine you install this on, you need:

- **Neovim ≥ 0.11** (0.12 recommended)
- **git**
- **Node.js + npm** (for the TypeScript server, Prettier, ESLint)
- **gcc/clang + make** (to compile Treesitter parsers)
- **ripgrep** (`rg`) and **fd** — recommended for `fzf-lua` search
- A **Nerd Font** in your terminal (for icons)

## Install

Back up any existing config, then clone this repo into place:

```sh
# Linux / macOS
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
git clone <YOUR_REPO_URL> ~/.config/nvim
nvim
```

First launch will:
1. Download all plugins (pinned to versions in `nvim-pack-lock.json`)
2. Install LSP servers / formatters via Mason
3. Compile Treesitter parsers

Give it a minute. Quit and reopen once it finishes.

## Updating

- Update plugins: `:lua vim.pack.update()` (then commit the changed `nvim-pack-lock.json`)
- Update tools: `:MasonToolsUpdate`
- Update parsers: `:TSUpdate`

## Layout

```
init.lua                 entry point, sets leader + loads modules
lua/config/options.lua   editor settings
lua/config/keymaps.lua   key mappings
lua/config/autocmds.lua  autocommands + custom commands
lua/config/plugins.lua   plugins, LSP, Treesitter, formatting
nvim-pack-lock.json      pinned plugin revisions (committed for reproducibility)
```

## Key bindings

Leader is `<Space>`.

| Key            | Action                          |
|----------------|---------------------------------|
| `<leader>ff`   | Find files                      |
| `<leader>fg`   | Live grep (project search)      |
| `<leader>fb`   | Find buffers                    |
| `<leader>fr`   | Resume last picker              |
| `<leader>/`    | Search in current buffer        |
| `<leader>f`    | Format buffer/selection         |
| `<leader>w`    | Save file                       |
| `grd`          | Go to definition                |
| `grr`          | References                      |
| `grn`          | Rename symbol                   |
| `gra`          | Code action                     |
| `K`            | Hover docs                      |
| `<leader>e`    | Show diagnostic float           |
| `<leader>th`   | Toggle inlay hints              |
| `]c` / `[c`    | Next / previous git hunk        |
| `<leader>gs`   | Stage hunk                      |
| `<leader>gp`   | Preview hunk                    |
| `<A-h/j/k/l>`  | Move between windows            |

Use `:FormatDisable` / `:FormatEnable` to toggle format-on-save.
