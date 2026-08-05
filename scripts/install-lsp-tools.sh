#!/usr/bin/env bash
# Installs AND updates the LSP servers, formatters, linters and the js-debug
# DAP adapter previously managed by mason.nvim. Rerun anytime to update
# everything to latest.
set -euo pipefail

BREW_PKGS=(lua-language-server deno marksman stylua)
NPM_PKGS=(
  @vtsls/language-server
  @tailwindcss/language-server
  vscode-langservers-extracted
  @fsouza/prettierd
  eslint_d
  oxlint
  oxfmt
)

echo "==> brew packages"
for pkg in "${BREW_PKGS[@]}"; do
  if brew list --formula "$pkg" >/dev/null 2>&1; then
    brew upgrade "$pkg" 2>/dev/null || echo "$pkg already up to date"
  else
    brew install "$pkg"
  fi
done

echo "==> npm global packages"
npm install -g "${NPM_PKGS[@]/%/@latest}"

echo "==> js-debug (DAP adapter)"
DEST="$HOME/.local/share/js-debug"
TAG=$(curl -fsSL https://api.github.com/repos/microsoft/vscode-js-debug/releases/latest |
  sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')
CURRENT=$(cat "$DEST/.version" 2>/dev/null || echo "none")
if [[ "$CURRENT" == "$TAG" ]]; then
  echo "js-debug $TAG already up to date"
else
  rm -rf "$DEST"
  mkdir -p "$DEST"
  curl -fsSL "https://github.com/microsoft/vscode-js-debug/releases/download/${TAG}/js-debug-dap-${TAG}.tar.gz" |
    tar -xz -C "$DEST"
  echo "$TAG" > "$DEST/.version"
  echo "js-debug $CURRENT -> $TAG"
fi

echo "==> done"
