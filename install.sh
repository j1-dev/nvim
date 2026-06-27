#!/usr/bin/env bash
#
# Clean install / repair for this Neovim config.
#
# Usage:
#   ./install.sh            # install plugins + tools (safe; keeps existing data)
#   ./install.sh --clean    # wipe Neovim's plugin/tool data first, then reinstall
#   ./install.sh --neovim   # also install latest Neovim from GitHub first
#
# Combine flags freely, e.g.  ./install.sh --neovim --clean
#
# This NEVER touches your config files (init.lua, lua/, lock file) or your code.
# --clean only removes downloaded plugins, Mason tools and Treesitter parsers,
# which are all re-downloaded from the pinned lock file.

set -euo pipefail

DATA="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

bold() { printf '\033[1m%s\033[0m\n' "$1"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$1"; }

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse flags (order-independent)
WANT_CLEAN=0
WANT_NEOVIM=0
for arg in "$@"; do
  case "$arg" in
    --clean)  WANT_CLEAN=1 ;;
    --neovim) WANT_NEOVIM=1 ;;
    *) warn "unknown flag: $arg" ;;
  esac
done

# Neovim version helper: prints major*100+minor (e.g. 0.11 -> 11, 0.9 -> 9)
nvim_minor() {
  command -v nvim >/dev/null 2>&1 || { echo -1; return; }
  nvim --version 2>/dev/null | head -n1 \
    | sed -E 's/.*v[0-9]+\.([0-9]+).*/\1/'
}

# --- 0. Neovim itself --------------------------------------------------------
bold "Checking Neovim version..."
minor="$(nvim_minor)"
if [ "$WANT_NEOVIM" -eq 1 ]; then
  bold "Installing latest Neovim from GitHub..."
  "$HERE/install-neovim.sh"
elif [ "$minor" -lt 0 ] 2>/dev/null; then
  warn "Neovim is not installed."
  warn "Run:  ./install.sh --neovim   (installs the latest from GitHub)"
elif [ "$minor" -lt 11 ] 2>/dev/null; then
  warn "Neovim 0.$minor is too old (need >= 0.11)."
  warn "Run:  ./install.sh --neovim   (installs the latest from GitHub)"
else
  ok "nvim ($(nvim --version | head -n1))"
fi

# --- 1. Dependency check -----------------------------------------------------
bold "Checking required tools..."
missing=0
check() {
  if command -v "$1" >/dev/null 2>&1; then
    ok "$1"
  else
    warn "MISSING: $1 ($2)"
    missing=1
  fi
}
check nvim "Neovim >= 0.11"
check git  "git"
check node "Node.js (TypeScript server, Prettier, ESLint)"
check npm  "npm"
check cc   "C compiler (or install gcc/clang) for Treesitter" || true
check make "make (Treesitter parsers)"
check rg   "ripgrep (recommended for fzf search)"
check fd   "fd (recommended for fzf file search)"

if [ "$missing" -ne 0 ]; then
  warn "Some tools are missing. Install them, then re-run this script."
  warn "(rg/fd are optional but recommended; nvim/git/node/npm/cc/make are required.)"
fi

# --- 2. Optional clean -------------------------------------------------------
if [ "$WANT_CLEAN" -eq 1 ]; then
  bold "Cleaning previous Neovim data (config is NOT touched)..."
  rm -rf "$DATA" "$STATE" "$CACHE"
  ok "removed plugins, Mason tools and parsers"
fi

# --- 3. Bootstrap ------------------------------------------------------------
bold "Installing plugins (from pinned lock file)..."
nvim --headless "+lua vim.defer_fn(function() vim.cmd('qa') end, 60000)" 2>&1 \
  | grep -iE "install|error" | tail -n 20 || true

bold "Installing LSP servers / formatters / tree-sitter CLI via Mason..."
nvim --headless "+MasonToolsInstall" \
  "+lua vim.defer_fn(function() vim.cmd('qa') end, 180000)" 2>&1 \
  | grep -iE "successfully installed|error" | tail -n 20 || true

bold "Compiling Treesitter parsers..."
nvim --headless "+TSUpdateSync" \
  "+lua vim.defer_fn(function() vim.cmd('qa') end, 240000)" 2>&1 \
  | grep -iE "installed|error" | tail -n 20 || true

bold "Done."
echo "Open Neovim normally (\`nvim\`). If anything still looks off, run:"
echo "  ./install.sh --clean"
