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
mkdir -p "$XDG_DATA_HOME/zsh" "$XDG_CACHE_HOME/zsh"

# ============================================================================
# PATH Configuration
# Purpose: Centralize all PATH modifications to prevent conflicts and ensure
# correct tool precedence. Earlier entries have higher priority.
# Note: typeset -U prevents duplicate entries in PATH
# ============================================================================
typeset -U PATH  # Ensures no duplicate entries in PATH

export PNPM_HOME="$HOME/Library/pnpm"
export ASDF_DATA_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"

# Cache Homebrew prefix for faster startup (hardcoded for Apple Silicon)
export HOMEBREW_PREFIX="/opt/homebrew"

export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PNPM_HOME:$HOMEBREW_PREFIX/opt/postgresql@18/bin:$HOMEBREW_PREFIX/bin:$ASDF_DATA_DIR/shims:$PATH"

# ============================================================================
# Oh My Zsh Configuration
# Purpose: Plugin framework for managing zsh extensions and themes
# ============================================================================
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Required plugins - installation instructions:
# fzf-tab: git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
# zsh-autosuggestions: git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# zsh-syntax-highlighting: git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
plugins=(fzf-tab git asdf zsh-autosuggestions zsh-syntax-highlighting docker)

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
setopt INC_APPEND_HISTORY     # Add commands immediately, not at shell exit

# ============================================================================
# Zsh Options
# Purpose: Configure shell behavior for better interactive experience
# ============================================================================
setopt AUTO_CD                # Type directory name to cd into it
setopt CORRECT                # Spell correction for commands
setopt INTERACTIVE_COMMENTS   # Allow comments in interactive shell
setopt NO_BEEP                # Disable beeping
setopt EXTENDED_GLOB          # Extended globbing capabilities
setopt NO_CASE_GLOB           # Case insensitive globbing
setopt NUMERIC_GLOB_SORT      # Sort filenames numerically when relevant

# ============================================================================
# Completions
# Purpose: Enable and optimize tab completion with caching for faster startup
# ============================================================================
# Add Homebrew completions (using cached prefix)
FPATH="$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH"

# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then
  export FPATH="$HOME/.zsh/completions:$FPATH"
fi

# Optimized compinit with caching (only rebuild once per day)
autoload -Uz compinit
local compinit_dump="$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"
if [[ -n $compinit_dump(#qN.mh+24) ]]; then
  compinit -d "$compinit_dump"
else
  compinit -C -d "$compinit_dump"
fi

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
hash -d downloads=~/Downloads
hash -d config=~/.config
hash -d desktop=~/Desktop

# ============================================================================
# fzf-tab Configuration
# Purpose: Enhanced tab completion with fuzzy finding and preview windows
# ============================================================================

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
# fzf Key Bindings
# ============================================================================
# Ctrl+R: Fuzzy search history
# Ctrl+T: Fuzzy file finder
# Alt+C:  Fuzzy cd into subdirectories
# Tab:    fzf-tab enhanced completion with preview
# Ctrl+E: Accept autosuggestion (zsh-autosuggestions)
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"

# ============================================================================
# Modular Configuration Loading
# Purpose: Load separate config files for better organization
# ============================================================================

# Source modular config files
local config_files=(
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
