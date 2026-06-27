# nvim-ide

My personal Neovim configuration — a lightweight TypeScript / backend IDE.

Built on **Neovim 0.12+** using the built-in `vim.pack` plugin manager (no
external bootstrap needed). Language servers, formatters and Treesitter parsers
auto-install on first launch.

## Features

- **LSP** for TypeScript/JavaScript (`ts_ls`), ESLint, JSON, and Lua
- **Autocompletion** via `mini.completion` (LSP-aware)
- **Treesitter** syntax highlighting & indentation (nvim-treesitter `main` branch)
- **Formatting** with Prettier (`prettierd`/`prettier`) — format on save
- **Fuzzy finding** with `fzf-lua`
- **Git** signs + hunk actions via `gitsigns`, plus **LazyGit** full TUI (`<leader>gg`)
- **File explorer** sidebar (`neo-tree`) on the right — VS Code style
- **Integrated terminal** (`toggleterm`) — toggle a shell with `<C-\>`
- **Custom start screen** (`alpha-nvim`) with a "J" splash + quick actions
- **Catppuccin (mocha)** colorscheme with a readable terminal palette
- **Theme selector** — live-preview picker (`<leader>ut`) across 18 themes; your
  choice is remembered across restarts. Includes a custom **dark2026** theme
  (recreated from VS Code Insiders' "Dark 2026"), which is the default.
- **Rainbow brackets** — `()`/`[]`/`{}` colored by nesting depth (VS Code-style)
- **Indent guides** — vertical lines marking indentation levels (`indent-blankline`)
- **Mason** auto-installs all tooling, **pinned plugin versions** via lock file

## Requirements

On any machine you install this on, you need:

- **Neovim ≥ 0.11** (0.12 recommended). Distro packages are often too old
  (e.g. Ubuntu ships 0.9) — use `./install-neovim.sh` to get the latest, see below.
- **git**
- **Node.js + npm** (for the TypeScript server, Prettier, ESLint)
- **gcc/clang + make** (compiler toolchain for building Treesitter parsers)
- The `tree-sitter` CLI is installed automatically via Mason (no manual step)
- **fzf** is installed automatically by `install.sh` if missing (to `~/.local/bin`)
- **lazygit** is installed automatically by `install.sh` if missing (to `~/.local/bin`)
- **ripgrep** (`rg`) and **fd** — recommended for `fzf-lua` search
- A **Nerd Font** in your terminal (for icons)

## Install

### Neovim too old (Ubuntu/Debian/etc.)?

Many distros package an outdated Neovim. This installs the **latest stable**
release straight from the official GitHub (prebuilt, no compiling, any distro):

```sh
~/.config/nvim/install-neovim.sh            # installs to ~/.local (no sudo)
# or:
~/.config/nvim/install-neovim.sh --system   # installs to /usr/local (sudo)
```

For a `~/.local` install, ensure `~/.local/bin` is on your `PATH`:
```sh
export PATH="$HOME/.local/bin:$PATH"   # add to ~/.bashrc or ~/.zshrc
```

Back up any existing config, then clone this repo into place:

```sh
# Linux / macOS
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null || true
git clone <YOUR_REPO_URL> ~/.config/nvim
~/.config/nvim/install.sh   # checks deps, installs plugins + tools + parsers
```

Or, if your distro's Neovim is too old, do it all in one shot (installs the
latest Neovim from GitHub first, then everything else):

```sh
~/.config/nvim/install.sh --neovim
```

Or just run `nvim` and let it bootstrap on first launch.

First launch / `install.sh` will:
1. Download all plugins (pinned to versions in `nvim-pack-lock.json`)
2. Install LSP servers / formatters / the `tree-sitter` CLI via Mason
3. Compile Treesitter parsers

Give it a minute. Quit and reopen once it finishes.

### Something failed / partial install?

If plugins half-installed (e.g. fzf or neo-tree missing), do a clean reinstall.
This wipes only the **downloaded data** (plugins, Mason tools, parsers) and
rebuilds from the pinned lock file — your config and code are untouched:

```sh
~/.config/nvim/install.sh --clean
```

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
| `<C-n>` / `<leader>n` | Toggle file explorer (right) |
| `<leader>R`    | Reveal current file in tree     |
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
| `<leader>ut`   | Choose colorscheme (live preview) |
| `<leader>th`   | Toggle inlay hints              |
| `]c` / `[c`    | Next / previous git hunk        |
| `<leader>gs`   | Stage hunk                      |
| `<leader>gp`   | Preview hunk                    |
| `<leader>gg`   | Open LazyGit (full git TUI)     |
| `<A-h/j/k/l>`  | Move between windows            |
| `gt` / `gT`    | Next / previous tab             |

Use `:FormatDisable` / `:FormatEnable` to toggle format-on-save.

## File explorer (neo-tree)

Toggle the tree with `<C-n>` or `<leader>n`. With the cursor on a file/folder
in the tree:

| Key       | Action                                                   |
|-----------|----------------------------------------------------------|
| `<Enter>` | Open in the current window                               |
| `s`       | Open in a **vertical split** (side-by-side, next to current file) |
| `S`       | Open in a horizontal split (above/below)                 |
| `t`       | Open in a **new tab**                                    |
| `q`       | Close the tree                                           |

After opening: move between split windows with `<A-h/j/k/l>` (or `<C-w>h/j/k/l`),
and between tabs with `gt` / `gT` (or `<num>gt` to jump to tab N).

## Integrated terminal (toggleterm)

Run git, terraform, npm, etc. without leaving Neovim.

| Key          | Action                                |
|--------------|---------------------------------------|
| `<C-\>`      | Toggle terminal (horizontal panel)    |
| `<leader>tf` | Open a floating terminal              |
| `<leader>tv` | Open a vertical (side) terminal       |
| `<leader>tt` | Open a terminal in a new tab          |
| `<Esc>`      | Leave terminal (insert) mode          |
| `<A-h/j/k/l>`| Jump from the terminal to other windows |

Inside the terminal, type commands normally. Press `<C-\>` again to hide it.
You can open numbered terminals too: `2<C-\>` opens/toggles terminal #2, etc.

The terminal opens at the **git project root** of the file you're editing
(falling back to the current working directory if it's not a git repo), so it
stays aligned with the folder shown in neo-tree.
