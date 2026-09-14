# ~/.zsh/aliases.zsh
# Shell aliases and command replacements
# Note: Navigation aliases (.., ..., ....) and grep are provided by Oh My Zsh

# ============================================================================
# File Listing (lsd)
# `ls` stays the standard binary so scripts and tools get plain output.
# ============================================================================
alias ll="lsd -la"
alias la="lsd -a"
alias lt="lsd --tree"
alias l="lsd -l"

# ============================================================================
# Modern Replacements
# Standard commands (cat, du, top, ps) are not shadowed. Call bat, dust,
# btop, procs directly when you want the decorated version.
# ============================================================================
alias y="yazi"
alias pg="pgcli"  # interactive postgres; use psql for scripts/pipes
alias lcli="litecli"  # interactive sqlite (autocomplete + syntax highlight)

# ============================================================================
# Git / Diff Tools
# ============================================================================
alias gdft="git dft"  # structural (syntax-aware) diff via difftastic
alias lg="lazygit"
alias gu="gitui"      # fast git TUI (Rust)
alias ghd="gh dash"   # GitHub PRs/issues dashboard

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


# ============================================================================
# Claude Code
# ============================================================================
# skips all permission prompts, and appends my communication rules
alias yolo='claude --dangerously-skip-permissions --append-system-prompt "$(cat ~/.claude/sr_opus_5_system_prompt.md)"'

# ============================================================================
# Caffeinate
# ============================================================================
alias caf-stop='launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.caffeinate.plist'
alias caf-start='launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.caffeinate.plist'
alias caf-status='launchctl list | grep caffeinate'
