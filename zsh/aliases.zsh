# ~/.zsh/aliases.zsh
# Shell aliases and command replacements
# Note: Navigation aliases (.., ..., ....) and grep are provided by Oh My Zsh

# ============================================================================
# File Listing (lsd)
# ============================================================================
alias ls="lsd"
alias ll="lsd -la"
alias la="lsd -a"
alias lt="lsd --tree"
alias l="lsd -l"

# ============================================================================
# Modern Replacements
# ============================================================================
alias cat="bat"
alias find="fd"
alias du="dust"
alias top="btop"
alias y="yazi"

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

# ============================================================================
# Clipboard
# ============================================================================
alias pbc="pbcopy"
alias pbp="pbpaste"

# ============================================================================
# Process Management
# ============================================================================
alias ports="lsof -iTCP -sTCP:LISTEN -n -P"

# ============================================================================
# Tmux
# ============================================================================
alias tp="tmux-project"

# Tmux - Prompt for session and window name before starting
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
