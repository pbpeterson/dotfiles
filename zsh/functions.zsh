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

VPN_LOG="/tmp/openvpn.log"

# Bring the VPN up in the background; takes the .ovpn file as an argument
vpn-up() {
  if [ -z "$1" ]; then
    echo "Usage: vpn-up <path-to-file.ovpn>"
    return 1
  fi
  sudo /opt/homebrew/sbin/openvpn --config "$1" --daemon --log "$VPN_LOG"
  echo "VPN starting in the background. Use 'vpn-log' to follow it."
}

# Follow the logs live (Ctrl+C exits the log WITHOUT dropping the VPN)
vpn-log() {
  sudo tail -f "$VPN_LOG"
}

# Disconnect
vpn-down() {
  sudo pkill openvpn && echo "VPN disconnected"
}

# ============================================================================
# Code Screenshots
# ============================================================================

# codeshot: Render a code file (or clipboard) to a PNG with the Kanagawa Wave
# theme, matching the Neovim / WezTerm look. Extra args pass through to silicon.
#   codeshot src/main.rs                 -> src/main.rs.png
#   codeshot src/main.rs out.png         -> out.png
#   codeshot src/main.rs --to-clipboard  -> copies PNG to clipboard
#   pbpaste | codeshot -l ts             -> render clipboard as TypeScript
codeshot() {
  local theme="$HOME/Library/Application Support/silicon/themes/kanagawa-wave.tmTheme"
  if [[ ! -f "$theme" ]]; then
    echo "codeshot: theme not found at $theme" >&2
    return 1
  fi

  local input="$1" output args
  if [[ -n "$input" && -f "$input" ]]; then
    shift
    output="${1:-${input}.png}"
    [[ -n "$1" && "$1" != -* ]] && shift
    args=(--output "$output" "$@")
    silicon "$input" --theme "$theme" --background "#16161D" "${args[@]}"
  else
    # No file given: read code from stdin (e.g. piped from pbpaste)
    silicon --theme "$theme" --background "#16161D" "$@"
  fi
}
