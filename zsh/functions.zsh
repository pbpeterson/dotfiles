# ~/.zsh/functions.zsh
# Custom shell functions

# ============================================================================
# Directory Navigation
# ============================================================================

# zz: Fuzzy find and jump to directory (zoxide + fzf)
zz() {
  local dir="$(zoxide query -i)"
  [[ -n "$dir" ]] && cd "$dir"
}

# ============================================================================
# Process Management
# ============================================================================

# pf: Fuzzy find and kill processes
pf() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m --height 40% --reverse | awk '{print $2}')

  if [[ -n "$pid" ]]; then
    echo "$pid" | xargs kill -${1:-9}
    echo "Killed process(es): $pid"
  fi
}

# ============================================================================
# Performance
# ============================================================================

# timezsh: Benchmark zsh startup time
timezsh() {
  local iterations="${1:-10}"

  echo "Running $iterations iterations..."
  for i in $(seq 1 $iterations); do
    local timing=$( (time zsh -i -c exit) 2>&1 | grep real | awk '{print $2}' )
    echo "  Run $i: $timing"
  done
}

# ============================================================================
# Help
# ============================================================================

# helpme: Show custom functions and aliases
helpme() {
  echo "=== Custom Functions ==="
  echo "  zz              - Fuzzy directory jump (zoxide + fzf)"
  echo "  pf [signal]     - Fuzzy process killer"
  echo "  timezsh [n]     - Benchmark zsh startup (default: 10 runs)"
  echo "  helpme          - Show this help"
  echo ""
  echo "=== Custom Aliases ==="
  echo "  Configuration:"
  echo "    zshconfig     - Edit ~/.zshrc"
  echo "    nvimconfig    - Edit nvim config"
  echo "    tmuxconfig    - Edit tmux config"
  echo "    reload        - Reload zsh config"
  echo ""
  echo "  Tools:"
  echo "    y             - yazi file manager"
  echo "    ports         - Show listening ports"
  echo "    pbc/pbp       - Clipboard copy/paste"
  echo ""
  echo "=== Git Functions ==="
  echo "  fbr             - Fuzzy branch checkout"
  echo "  fco             - Fuzzy commit checkout"
  echo "  fshow           - Fuzzy git log browser"
  echo "  fstash          - Fuzzy stash browser"
  echo "  gadd            - Fuzzy git add"
  echo "  gdiff           - Fuzzy git diff"
  echo "  greset          - Fuzzy git unstage"
}
