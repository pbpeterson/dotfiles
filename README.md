# Dotfiles

Personal configuration files for Zsh, Tmux, and Neovim.

## Features

### Zsh
- **Modular configuration** - Organized into separate files for aliases, functions, git helpers, and tools
- **Modern CLI tools** - Integrates lsd, bat, fd, ripgrep, btop, and more
- **Enhanced git workflow** - Fuzzy finding for branches, commits, and stashes
- **Smart navigation** - Zoxide integration and custom directory bookmarks
- **Performance optimized** - Lazy loading and caching for fast startup

### Tmux
- **Vim-style keybindings** - Navigate panes with hjkl
- **Custom prefix** - Changed from `C-b` to `C-s`
- **Session persistence** - Auto-save and restore with tmux-resurrect
- **Catppuccin theme** - Beautiful Mocha colorscheme
- **Smart window management** - Custom naming prompts and navigation

### Neovim
- **LazyVim-based** - Modern Neovim distribution
- **LSP support** - TypeScript, Deno, Lua, Tailwind CSS
- **DAP debugging** - Integrated debugging support
- **Code quality** - Formatting and linting configured
- **Quality of life** - Custom keymaps and enhancements

## Quick Start

### One-line Install

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles && cd ~/dotfiles && ./install.sh
```

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

2. Run the installation script:
```bash
./install.sh
```

3. Follow the prompts and restart your terminal

## What Gets Installed

### Package Manager
- **Homebrew** - Package manager for macOS/Linux

### CLI Tools
- `tmux` - Terminal multiplexer
- `neovim` - Modern text editor
- `lsd` - Modern replacement for ls
- `bat` - Modern replacement for cat
- `fd` - Modern replacement for find
- `ripgrep` - Modern replacement for grep
- `fzf` - Fuzzy finder
- `btop` - Resource monitor
- `zoxide` - Smart directory jumper
- `yazi` - Terminal file manager
- `dust` - Modern replacement for du

### Shell Framework
- **Oh My Zsh** - Zsh configuration framework
- **fzf-tab** - Tab completion with fzf
- **zsh-autosuggestions** - Fish-like autosuggestions
- **zsh-syntax-highlighting** - Syntax highlighting for commands

### Version Management
- **ASDF** - Multi-language version manager

### Tmux Plugins
- **TPM** - Tmux Plugin Manager
- **tmux-resurrect** - Session persistence
- **tmux-continuum** - Automatic session saving
- **vim-tmux-navigator** - Seamless vim/tmux navigation
- **tmux-fzf** - Fuzzy finding in tmux
- **Catppuccin** - Beautiful theme

## File Structure

```
dotfiles/
├── install.sh           # Installation script
├── README.md           # This file
├── .gitignore          # Git ignore rules
├── zshrc               # Main Zsh configuration
├── zsh/                # Modular Zsh configs
│   ├── aliases.zsh     # Command aliases
│   ├── functions.zsh   # Custom functions
│   ├── git.zsh         # Git helpers
│   ├── tools.zsh       # Tool initializations
│   └── completions/    # Shell completions
├── tmux.conf           # Tmux configuration
├── tmux/               # Tmux scripts and plugins
│   ├── scripts/        # Custom scripts
│   └── plugins/        # Tmux plugins (git cloned)
└── nvim/               # Neovim configuration
    ├── init.lua        # Entry point
    └── lua/            # Lua configs
        ├── config/     # Core config
        └── plugins/    # Plugin configs
```

## Key Bindings

### Zsh
- `Ctrl+R` - Fuzzy search command history
- `Ctrl+T` - Fuzzy file finder
- `Alt+C` - Fuzzy directory navigation
- `Ctrl+E` - Accept autosuggestion

### Tmux
- `C-s` - Prefix key
- `prefix + |` - Split pane horizontally
- `prefix + -` - Split pane vertically
- `prefix + hjkl` - Navigate panes
- `Alt + hjkl` - Navigate panes (no prefix)
- `prefix + HJKL` - Resize panes
- `prefix + r` - Reload config
- `prefix + c` - New window with custom name

### Custom Commands

#### Directory Navigation
- `z <dir>` - Jump to directory (zoxide)
- `zz` - Interactive directory jump
- `bm add <name>` - Bookmark current directory
- `bm jump` - Jump to bookmark

#### Git Helpers
- `fbr` - Fuzzy branch checkout
- `fco` - Fuzzy commit browser
- `fshow` - Interactive git log
- `fstash` - Fuzzy stash browser
- `gadd` - Fuzzy git add
- `gdiff` - Fuzzy git diff
- `greset` - Fuzzy git reset

#### Utilities
- `pf [signal]` - Fuzzy process killer
- `timezsh [n]` - Benchmark zsh startup
- `helpme` - Show custom functions

## Customization

### Machine-Specific Settings

Create `~/.zshrc.local` for machine-specific configurations that won't be committed:

```bash
# Example: Work-specific aliases
export WORK_DIR="~/work/projects"
alias work="cd $WORK_DIR"
```

### Adding Custom Aliases

Edit `zsh/aliases.zsh` to add your own aliases.

### Modifying Tmux Keybindings

Edit `tmux.conf` to customize keybindings.

### Adding Neovim Plugins

Add new plugin configs in `nvim/lua/plugins/`.

## Updating

To update the dotfiles:

```bash
cd ~/dotfiles
git pull
```

To update installed tools:

```bash
brew update && brew upgrade
```

## Troubleshooting

### Zsh plugins not loading
Run the installation commands from `zshrc` comments:
```bash
git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Tmux plugins not working
Press `prefix + I` (capital i) to install plugins via TPM.

### Neovim plugins not loading
Open nvim and run `:Lazy sync`

## License

MIT License - Feel free to use and modify as needed.

## Credits

- [Oh My Zsh](https://ohmyz.sh/)
- [LazyVim](https://www.lazyvim.org/)
- [Catppuccin](https://github.com/catppuccin/catppuccin)
- [TPM](https://github.com/tmux-plugins/tpm)
