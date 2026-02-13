# ~/.zsh/tools.zsh
# Tool initializations with lazy loading for better performance

# Helper: cache a command's output, invalidate when the binary changes
_cached_eval() {
  local name="$1" cmd="$2"
  local cache_file="$XDG_CACHE_HOME/zsh/${name}.zsh"
  local bin_path="${3:-$(whence -p ${name})}"

  if [[ ! -f "$cache_file" || "$bin_path" -nt "$cache_file" ]]; then
    mkdir -p "$XDG_CACHE_HOME/zsh"
    eval "$cmd" > "$cache_file"
  fi
  source "$cache_file"
}

# ============================================================================
# Zoxide (smarter cd)
# ============================================================================
_cached_eval zoxide "zoxide init zsh"
alias cd="z"

# ============================================================================
# FZF - Fuzzy Finder
# ============================================================================
_cached_eval fzf "fzf --zsh"

# Catppuccin Mocha theme colors
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --info=inline
  --marker="*"
  --pointer="▶"
  --prompt="❯ "
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#cba6f7
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#89b4fa
  --color=info:#89b4fa,prompt:#89dceb,pointer:#89dceb
  --color=marker:#a6e3a1,spinner:#a6e3a1,header:#a6e3a1
'

# Use fd for fzf (faster than find)
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
