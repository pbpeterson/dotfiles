# ~/.zsh/tools.zsh
# Tool initializations with lazy loading for better performance

# ============================================================================
# Zoxide (smarter cd)
# ============================================================================
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
  alias cd="z"  # Replace cd with zoxide
fi

# ============================================================================
# FZF - Fuzzy Finder
# ============================================================================
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)

  # Tokyo Night theme colors for visual consistency with tmux
  export FZF_DEFAULT_OPTS='
    --height 40%
    --layout=reverse
    --border
    --info=inline
    --marker="*"
    --pointer="▶"
    --prompt="❯ "
    --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
    --color=fg+:#c0caf5,bg+:#292e42,hl+:#7dcfff
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a
  '

  # Use fd if available (faster than find)
  if command -v fd &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

    # Enhanced file preview with syntax highlighting
    export FZF_CTRL_T_OPTS="
      --preview 'bat --color=always --style=numbers --line-range=:100 {} 2>/dev/null || lsd -1 --color=always {}'
      --preview-window right:60%
    "

    # Enhanced directory preview with git status
    export FZF_ALT_C_OPTS="
      --preview 'lsd -1 --color=always {} && echo && git -C {} status 2>/dev/null'
      --preview-window right:60%
    "
  fi
fi

# ============================================================================
# ASDF - Lazy Loading
# Purpose: Defer asdf initialization until first use to improve startup time
# ============================================================================

# Check if asdf is already loaded (via Oh My Zsh plugin)
if ! command -v asdf &> /dev/null; then
  # Lazy load asdf
  asdf() {
    unfunction asdf
    export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
    if [[ -f "$ASDF_DATA_DIR/asdf.sh" ]]; then
      source "$ASDF_DATA_DIR/asdf.sh"
    fi
    asdf "$@"
  }
fi
