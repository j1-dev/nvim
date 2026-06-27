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

# Install the fzf binary from the official GitHub releases into ~/.local/bin
# (no sudo, any distro). fzf is required by the fuzzy finder (fzf-lua).
install_fzf() {
  local asset url tmp
  case "$(uname -m)" in
    x86_64|amd64)  asset='linux_amd64' ;;
    aarch64|arm64) asset='linux_arm64' ;;
    armv7l|armhf)  asset='linux_armv7' ;;
    *) warn "fzf: unsupported architecture $(uname -m)"; return 1 ;;
  esac
  url="$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest \
        | grep -oE "https://[^\"]*fzf-[0-9.]+-${asset}\.tar\.gz" | head -n1)"
  [ -n "$url" ] || { warn "fzf: could not find a release for $asset"; return 1; }
  tmp="$(mktemp -d)"
  curl -fsSL "$url" -o "$tmp/fzf.tar.gz" || { rm -rf "$tmp"; return 1; }
  tar -xzf "$tmp/fzf.tar.gz" -C "$tmp" || { rm -rf "$tmp"; return 1; }
  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$tmp/fzf" "$HOME/.local/bin/fzf"
  rm -rf "$tmp"
}

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

# Neovim version helper: prints the minor version (e.g. 0.11 -> 11, 0.9 -> 9)
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

# fzf is required by the fuzzy finder (fzf-lua). Auto-install if missing.
if command -v fzf >/dev/null 2>&1; then
  ok "fzf"
elif [ -x "$HOME/.local/bin/fzf" ]; then
  ok "fzf (~/.local/bin/fzf)"
else
  bold "fzf not found — installing to ~/.local/bin..."
  if install_fzf; then
    ok "fzf installed ($("$HOME/.local/bin/fzf" --version 2>/dev/null | awk '{print $1}'))"
    command -v fzf >/dev/null 2>&1 || warn "Add ~/.local/bin to your PATH (e.g. in ~/.bashrc or ~/.zshrc)"
  else
    warn "Could not auto-install fzf. Install it manually: https://github.com/junegunn/fzf"
  fi
fi

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
# Make Mason's bin dir visible so the `tree-sitter` CLI can be found when
# compiling parsers (Mason installs it there).
export PATH="$DATA/mason/bin:$PATH"

LOG="$(mktemp)"
trap 'rm -f "$LOG"' EXIT

# Step 1: install plugins. vim.pack installs synchronously during startup.
bold "Installing plugins (from pinned lock file)..."
nvim --headless "+qa" >>"$LOG" 2>&1 || true
ok "plugins installed"

# Step 2: Mason tools (LSP servers, formatters, tree-sitter CLI) + parser
# compilation, sequenced so the tree-sitter CLI exists before parsers build.
# All the noisy progress output goes to the log; we print clean status below.
bold "Installing LSP servers / formatters / tree-sitter CLI (Mason)..."
bold "Compiling Treesitter parsers (this can take a minute)..."
nvim --headless -c "lua dofile('$HERE/scripts/bootstrap.lua')" >>"$LOG" 2>&1 || true

# Report based on what actually landed on disk. The `main` branch installs
# compiled parsers under <data>/site/parser/.
parser_dir="$DATA/site/parser"
installed_parsers=0
if [ -d "$parser_dir" ]; then
  installed_parsers="$(find "$parser_dir" -maxdepth 1 -name '*.so' 2>/dev/null | wc -l | tr -d ' ')"
fi
if [ "${installed_parsers:-0}" -gt 0 ]; then
  ok "Mason tools installed"
  ok "$installed_parsers Treesitter parsers compiled"
else
  warn "No Treesitter parsers were compiled. Check that 'cc'/'make' work, then re-run."
  tr '\r' '\n' < "$LOG" | grep -iE 'error' | grep -vi 'tree-sitter build' | tail -n 10
fi

bold "Done."
echo "Open Neovim normally (\`nvim\`). If anything still looks off, run:"
echo "  ./install.sh --clean"
