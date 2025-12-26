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
# Bookmarks
# ============================================================================

# bm: Directory bookmark manager
bm() {
  local bookmarks_file="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/bookmarks"

  case "$1" in
    add)
      if [[ -z "$2" ]]; then
        echo "Usage: bm add <name> [path]"
        return 1
      fi
      local name="$2"
      local path="${3:-$PWD}"
      mkdir -p "$(dirname "$bookmarks_file")"
      echo "$name=$path" >> "$bookmarks_file"
      echo "Bookmark added: $name -> $path"
      ;;
    list|ls)
      if [[ -f "$bookmarks_file" ]]; then
        cat "$bookmarks_file"
      else
        echo "No bookmarks found"
      fi
      ;;
    jump|j)
      if [[ ! -f "$bookmarks_file" ]]; then
        echo "No bookmarks found"
        return 1
      fi
      if command -v fzf &> /dev/null; then
        local selection=$(cat "$bookmarks_file" | fzf --height 40% --reverse)
        [[ -n "$selection" ]] && cd "${selection#*=}"
      else
        echo "fzf not installed. Use: bm list"
      fi
      ;;
    rm|remove)
      if [[ -z "$2" ]]; then
        echo "Usage: bm rm <name>"
        return 1
      fi
      if [[ -f "$bookmarks_file" ]]; then
        sed -i.bak "/^$2=/d" "$bookmarks_file" && rm "${bookmarks_file}.bak"
        echo "Bookmark removed: $2"
      fi
      ;;
    *)
      echo "Usage: bm {add|list|jump|rm}"
      echo ""
      echo "Commands:"
      echo "  add <name> [path]  - Add bookmark (defaults to current dir)"
      echo "  list               - List all bookmarks"
      echo "  jump               - Fuzzy find and jump to bookmark"
      echo "  rm <name>          - Remove bookmark"
      ;;
  esac
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
  local total=0
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
  echo "  bm              - Bookmark manager (add/list/jump/rm)"
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
  echo "  Navigation:"
  echo "    ..            - cd .."
  echo "    ...           - cd ../.."
  echo "    ....          - cd ../../.."
  echo ""
  echo "  Tools:"
  echo "    y             - yazi file manager"
  echo "    ports         - Show listening ports"
  echo "    pbc/pbp       - Clipboard copy/paste"
  echo ""
  echo "=== Git Aliases (from Oh My Zsh) ==="
  echo "  Run 'alias | grep git' to see all git aliases"
}
