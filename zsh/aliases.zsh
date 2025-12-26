# ~/.zsh/aliases.zsh
# Shell aliases and command replacements

# ============================================================================
# File Listing (lsd)
# ============================================================================
if command -v lsd &> /dev/null; then
  alias ls="lsd"
  alias ll="lsd -la"
  alias la="lsd -a"
  alias lt="lsd --tree"
  alias l="lsd -l"
fi

# ============================================================================
# File Manager
# ============================================================================
command -v yazi &> /dev/null && alias y="yazi"

# ============================================================================
# Navigation
# ============================================================================
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# ============================================================================
# Safety Nets
# ============================================================================
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# ============================================================================
# Convenience
# ============================================================================
alias reload="source ~/.zshrc"
alias zshconfig="$EDITOR ~/.zshrc"
alias nvimconfig="$EDITOR ~/.config/nvim"
alias tmuxconfig="$EDITOR ~/.tmux.conf"
alias grep="grep --color=auto"

# ============================================================================
# Modern Replacements (only if installed)
# ============================================================================
command -v bat &> /dev/null && alias cat="bat"
command -v fd &> /dev/null && alias find="fd"
command -v dust &> /dev/null && alias du="dust"
command -v btop &> /dev/null && alias top="btop"

# ============================================================================
# Clipboard (cross-platform)
# ============================================================================
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias pbc="pbcopy"
  alias pbp="pbpaste"
elif command -v xclip &> /dev/null; then
  alias pbc="xclip -selection clipboard"
  alias pbp="xclip -selection clipboard -o"
elif command -v wl-copy &> /dev/null; then
  alias pbc="wl-copy"
  alias pbp="wl-paste"
fi

# ============================================================================
# Process Management
# ============================================================================
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"

# ============================================================================
# Tmux - Prompt for session and window name before starting
# ============================================================================
tmux() {
  if [[ $# -eq 0 ]]; then
    printf "Session name: "
    read session_name
    if [[ -z "$session_name" ]]; then
      echo "Cancelled - no session name provided"
      return 1
    fi

    printf "Window name: "
    read window_name
    if [[ -z "$window_name" ]]; then
      echo "Cancelled - no window name provided"
      return 1
    fi

    command tmux new-session -s "$session_name" -n "$window_name"
  else
    command tmux "$@"
  fi
}
