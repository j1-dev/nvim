#!/usr/bin/env bash
#
# Install the latest stable Neovim from the official GitHub releases.
# Distro-agnostic: downloads the prebuilt tarball (no compiling required).
#
# Usage:
#   ./install-neovim.sh            # install to ~/.local (no sudo needed)
#   ./install-neovim.sh --system   # install to /usr/local (uses sudo)
#
# After a ~/.local install, make sure ~/.local/bin is on your PATH:
#   export PATH="$HOME/.local/bin:$PATH"   # add to ~/.bashrc or ~/.zshrc

set -euo pipefail

REPO="neovim/neovim"
SYSTEM=0
[ "${1:-}" = "--system" ] && SYSTEM=1

bold() { printf '\033[1m%s\033[0m\n' "$1"; }
die()  { printf '\033[31merror:\033[0m %s\n' "$1" >&2; exit 1; }

for t in curl tar uname; do
  command -v "$t" >/dev/null 2>&1 || die "missing required tool: $t"
done

# --- Detect architecture -> release asset name ------------------------------
arch="$(uname -m)"
case "$arch" in
  x86_64|amd64) candidates=("nvim-linux-x86_64.tar.gz" "nvim-linux64.tar.gz") ;;
  aarch64|arm64) candidates=("nvim-linux-arm64.tar.gz") ;;
  *) die "unsupported architecture: $arch" ;;
esac

# --- Find a working download URL (asset names changed across versions) ------
base="https://github.com/$REPO/releases/latest/download"
url=""
for asset in "${candidates[@]}"; do
  if curl -fsIL "$base/$asset" >/dev/null 2>&1; then
    url="$base/$asset"
    break
  fi
done
[ -n "$url" ] || die "could not find a prebuilt Neovim release for arch '$arch'"

bold "Downloading latest stable Neovim ($arch)..."
echo "  $url"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
curl -fsSL "$url" -o "$tmp/nvim.tar.gz"
tar -xzf "$tmp/nvim.tar.gz" -C "$tmp"

# extracted dir is nvim-linux-x86_64/ (or nvim-linux64/, etc.)
src="$(find "$tmp" -maxdepth 1 -type d -name 'nvim-*' | head -n1)"
[ -d "$src" ] || die "unexpected archive layout"

# --- Install ----------------------------------------------------------------
if [ "$SYSTEM" -eq 1 ]; then
  prefix="/usr/local"
  bold "Installing to $prefix (sudo)..."
  sudo rm -rf "$prefix/lib/nvim" "$prefix/share/nvim"
  sudo cp -r "$src"/* "$prefix/"
  bin="$prefix/bin/nvim"
else
  prefix="$HOME/.local"
  bold "Installing to $prefix ..."
  mkdir -p "$prefix/bin" "$prefix/lib" "$prefix/share"
  rm -rf "$prefix/lib/nvim" "$prefix/share/nvim" "$prefix/opt/nvim"
  mkdir -p "$prefix/opt"
  cp -r "$src" "$prefix/opt/nvim"
  ln -sf "$prefix/opt/nvim/bin/nvim" "$prefix/bin/nvim"
  bin="$prefix/bin/nvim"
fi

bold "Installed: $("$bin" --version | head -n1)"

if [ "$SYSTEM" -eq 0 ] && ! command -v nvim >/dev/null 2>&1; then
  printf '\033[33m!\033[0m Add ~/.local/bin to your PATH:\n'
  printf '    export PATH="$HOME/.local/bin:$PATH"   # add to ~/.bashrc or ~/.zshrc\n'
fi
