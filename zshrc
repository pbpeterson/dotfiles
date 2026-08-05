# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ~/.zshrc - Zsh configuration
# Last updated: 2025-12-22
# Tested on: macOS with Homebrew

# ============================================================================
# Startup Performance Debugging
# ============================================================================
# Uncomment the following lines to profile zsh startup time:
# zmodload zsh/zprof  # Enable profiling (add at top)
# zprof              # Show profile results (add at bottom)

# ============================================================================
# XDG Base Directory Support
# ============================================================================
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Create directories if they don't exist
[[ -d "$XDG_DATA_HOME/zsh" ]] || mkdir -p "$XDG_DATA_HOME/zsh" "$XDG_CACHE_HOME/zsh"

# ============================================================================
# PATH Configuration
# Purpose: Centralize all PATH modifications to prevent conflicts and ensure
# correct tool precedence. Earlier entries have higher priority.
# Note: typeset -U prevents duplicate entries in PATH
# ============================================================================
typeset -U PATH fpath  # Ensures no duplicate entries

export PNPM_HOME="$HOME/Library/pnpm"
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
# Go binaries (go install drops here; GOPATH defaults to ~/go)
export GOBIN="$HOME/go/bin"

# Cache Homebrew prefix for faster startup (hardcoded for Apple Silicon)
export HOMEBREW_PREFIX="/opt/homebrew"

# Silence zoxide's init-order doctor warning (init is intentionally last in zshrc)
export _ZO_DOCTOR=0

export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PNPM_HOME:$GOBIN:$HOMEBREW_PREFIX/opt/sqlite/bin:$HOMEBREW_PREFIX/opt/postgresql@18/bin:$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/opt/openvpn/sbin:$ASDF_DATA_DIR/shims:$PATH"

# Homebrew SQLite (override macOS system version)
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/sqlite/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/sqlite/include"
export PKG_CONFIG_PATH="$HOMEBREW_PREFIX/opt/sqlite/lib/pkgconfig"

# ============================================================================
# Oh My Zsh Configuration
# Purpose: Plugin framework for managing zsh extensions and themes
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Startup perf: skip Oh My Zsh's auto-update prompt (run `omz update` manually)
# and its insecure-completion-dir audit (compaudit), which add ~30-40ms.
zstyle ':omz:update' mode disabled
export ZSH_DISABLE_COMPFIX=true
# Point OMZ's own compinit at the XDG cache dump (OMZ runs compinit for us;
# only set if unset so OMZ's default ~/.zcompdump-* isn't used).
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"

# Required plugins - installation instructions:
# fzf-tab: git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
# zsh-autosuggestions: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# fast-syntax-highlighting: git clone https://github.com/zdharma-continuum/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
# Rebind autosuggest widgets once instead of on every prompt; noticeably lower
# per-keystroke latency in long-lived shells.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
# Skip autosuggestions for very long buffers (e.g. big pastes into the prompt)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40

plugins=(fzf-tab git zsh-autosuggestions fast-syntax-highlighting)

# Completion search paths must be in fpath BEFORE OMZ runs compinit.
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"
fpath=($HOME/.zsh/completions $fpath)

# Load Oh My Zsh with error handling
if [[ -f $ZSH/oh-my-zsh.sh ]]; then
  source $ZSH/oh-my-zsh.sh
else
  echo "Warning: Oh My Zsh not found at $ZSH"
fi

# ============================================================================
# History Configuration
# Purpose: Optimize command history storage and retrieval for better workflow
# ============================================================================
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$XDG_DATA_HOME/zsh/history"

setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_IGNORE_DUPS       # Don't record duplicate entries
setopt HIST_IGNORE_ALL_DUPS   # Delete old duplicate when new entry is added
setopt HIST_IGNORE_SPACE      # Don't record entries starting with a space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks before recording
setopt HIST_VERIFY            # Show command with history expansion before running
setopt APPEND_HISTORY         # Append to history file, don't overwrite
setopt HIST_FIND_NO_DUPS      # Don't show duplicates when searching history

# ============================================================================
# Zsh Options
# Purpose: Configure shell behavior for better interactive experience
# ============================================================================
setopt AUTO_CD                # Type directory name to cd into it
setopt INTERACTIVE_COMMENTS   # Allow comments in interactive shell
setopt NO_BEEP                # Disable beeping
setopt EXTENDED_GLOB          # Extended globbing capabilities
setopt NO_CASE_GLOB           # Case insensitive globbing
setopt NUMERIC_GLOB_SORT      # Sort filenames numerically when relevant

# Key bindings
bindkey '^L' clear-screen       # Ctrl+L to clear terminal

# ============================================================================
# Completions
# Purpose: Enable and optimize tab completion with caching for faster startup
# ============================================================================
# compinit is handled by Oh My Zsh (it autoloads + compiles the dump at
# $ZSH_COMPDUMP). fpath entries are added above, before OMZ is sourced.

# ============================================================================
# Environment Variables
# Purpose: Set global environment variables for tools and applications
# ============================================================================
export PGDATABASE=postgres

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ============================================================================
# Directory Shortcuts (use with ~name)
# ============================================================================
hash -d projects=~/Projects 2>/dev/null
hash -d downloads=~/Downloads 2>/dev/null
hash -d config=~/.config 2>/dev/null
hash -d desktop=~/Desktop 2>/dev/null

# ============================================================================
# fzf-tab Configuration
# Purpose: Enhanced tab completion with fuzzy finding and preview windows
# ============================================================================

# Cache slow completion results (brew, git, npm completions etc.)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

# Enable completion for options/flags
zstyle ':completion:*' complete-options true

# Show descriptions for options
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'

# Tilde and path expansion
zstyle ':completion:*' expand yes
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-dirs-first true

# Preview directories and files
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:100 $realpath 2>/dev/null || lsd -1 --color=always $realpath'

# Switch between groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'

# ============================================================================
# Modular Configuration Loading
# Purpose: Load separate config files for better organization
# ============================================================================

# Source modular config files
config_files=(
  "$HOME/.zsh/aliases.zsh"
  "$HOME/.zsh/functions.zsh"
  "$HOME/.zsh/tools.zsh"
  "$HOME/.zsh/git.zsh"
)

for config_file in $config_files; do
  [[ -f "$config_file" ]] && source "$config_file"
done

# ============================================================================
# Local Configuration
# Purpose: Machine-specific settings (work vs personal, local overrides)
# ============================================================================
# Source local config if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ============================================================================
# Zoxide (smarter cd) — MUST be last: its doctor check requires that no other
# shell-config init runs after it. _cached_eval is defined in ~/.zsh/tools.zsh.
# ============================================================================
_cached_eval zoxide "zoxide init zsh"
alias cd="z"


alias nv="NVIM_APPNAME=nvim_native nvim"

# Update LSP servers/formatters/linters/DAP (ex-mason, now brew + npm + GitHub)
alias lspup="$HOME/dotfiles/scripts/install-lsp-tools.sh"
