# Packages that the configs in this repo call.
# Install: brew bundle --file=Brewfile   (or: ./install.sh bootstrap)
# Check:   brew bundle check --file=Brewfile
#
# Not listed on purpose:
#   kitty  Install it from https://sw.kovidgoyal.net/kitty/ or add the cask yourself.
#   atuin  The init block in zsh/tools.zsh is guarded. Install it only if you want it.

# Shell
brew "asdf"                 # runtime version manager (zsh/zshrc, zsh/tools.zsh)
brew "bat"                  # file preview in fzf and fzf-tab
brew "btop"                 # process monitor
brew "dust"                 # disk usage
brew "fd"                   # file search (fzf, tmux-project)
brew "fzf"                  # fuzzy finder (zsh, tmux scripts, tmux-fzf)
brew "jq"                   # JSON processor for helper scripts
brew "lsd"                  # ls replacement (aliases, fzf-tab preview)
brew "procs"                # ps replacement
brew "ripgrep"              # text search (nvim pickers)
brew "yazi"                 # terminal file manager
brew "zoxide"               # directory jumper (replaces cd)

# Git
brew "difftastic"           # syntax-aware diff (gdft)
brew "gh"                   # GitHub CLI (ghd)
brew "gitui"                # git TUI (gu)
brew "lazygit"              # git TUI (lg, tmux prefix + g)

# Terminal multiplexer and editor
brew "tmux"
brew "neovim"
brew "tree-sitter-cli"      # nvim-treesitter builds parsers with it
brew "imagemagick"          # image.nvim (magick_cli processor)
brew "resvg"                # SvgPreview command in nvim
brew "silicon"              # code screenshots (codeshot, nvim)

# Language servers and formatters (scripts/install-lsp-tools.sh updates them)
brew "deno"
brew "lua-language-server"
brew "marksman"
brew "node"                 # npm installs the other language servers
brew "stylua"

# Databases and network
brew "litecli"              # sqlite client (lcli)
brew "pgcli"                # postgres client (pg)
brew "postgresql@18"        # on PATH in zsh/zshrc
brew "sqlite"               # on PATH and in the build flags in zsh/zshrc
brew "openvpn"              # vpn-up, vpn-down

# Terminal and fonts
cask "wezterm"
cask "font-jetbrains-mono-nerd-font"
cask "font-symbols-only-nerd-font"
