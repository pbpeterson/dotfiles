#!/usr/bin/env bash

# Dotfiles Installation Script
# Installs all dependencies and sets up the environment

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
    print_success "Detected OS: $OS"
}

# Install Homebrew
install_homebrew() {
    print_step "Installing Homebrew..."

    if command -v brew &> /dev/null; then
        print_warning "Homebrew already installed"
        return
    fi

    if [[ "$OS" == "macos" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    elif [[ "$OS" == "linux" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    print_success "Homebrew installed"
}

# Install CLI tools via Homebrew
install_cli_tools() {
    print_step "Installing CLI tools..."

    local tools=(
        "tmux"          # Terminal multiplexer
        "neovim"        # Modern vim
        "lsd"           # Modern ls
        "bat"           # Modern cat
        "fd"            # Modern find
        "ripgrep"       # Modern grep
        "fzf"           # Fuzzy finder
        "btop"          # Modern top
        "zoxide"        # Smart cd
        "git"           # Version control
        "yazi"          # Terminal file manager
        "dust"          # Modern du
    )

    for tool in "${tools[@]}"; do
        if brew list "$tool" &> /dev/null; then
            print_warning "$tool already installed"
        else
            print_step "Installing $tool..."
            brew install "$tool"
            print_success "$tool installed"
        fi
    done
}

# Install Oh My Zsh
install_oh_my_zsh() {
    print_step "Installing Oh My Zsh..."

    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_warning "Oh My Zsh already installed"
        return
    fi

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed"
}

# Install Zsh plugins
install_zsh_plugins() {
    print_step "Installing Zsh plugins..."

    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    local plugins=(
        "fzf-tab|https://github.com/Aloxaf/fzf-tab"
        "zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions"
        "zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting"
    )

    for entry in "${plugins[@]}"; do
        local name="${entry%%|*}"
        local url="${entry##*|}"
        if [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]]; then
            print_step "Installing $name..."
            if git clone "$url" "$ZSH_CUSTOM/plugins/$name"; then
                print_success "$name installed"
            else
                print_error "Failed to clone $name"
            fi
        else
            print_warning "$name already installed"
        fi
    done
}

# Install ASDF (version manager)
install_asdf() {
    print_step "Installing ASDF..."

    if [[ -d "$HOME/.asdf" ]]; then
        print_warning "ASDF already installed"
        return
    fi

    local asdf_version
    asdf_version=$(git ls-remote --tags --sort=-v:refname https://github.com/asdf-vm/asdf.git "v*" | head -1 | sed 's/.*refs\/tags\///')
    if [[ -z "$asdf_version" ]]; then
        asdf_version="v0.14.1"
        print_warning "Could not fetch latest ASDF version, falling back to $asdf_version"
    fi
    print_step "Installing ASDF $asdf_version..."
    git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch "$asdf_version"
    print_success "ASDF installed"
}

# Setup dotfiles symlinks
setup_symlinks() {
    print_step "Setting up dotfiles symlinks..."

    local DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

    # Backup existing files (handles regular files, directories, and symlinks)
    backup_if_exists() {
        if [[ -L "$1" ]]; then
            print_warning "Removing existing symlink $1"
            rm "$1"
        elif [[ -f "$1" ]] || [[ -d "$1" ]]; then
            local backup="$1.backup.$(date +%Y%m%d_%H%M%S)"
            print_warning "Backing up $1 to $backup"
            mv "$1" "$backup"
        fi
    }

    # Zsh
    backup_if_exists "$HOME/.zshrc"
    backup_if_exists "$HOME/.zsh"
    ln -sf "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"
    ln -sfn "$DOTFILES_DIR/zsh" "$HOME/.zsh"
    print_success "Zsh config linked"

    # Tmux
    backup_if_exists "$HOME/.tmux.conf"
    backup_if_exists "$HOME/.tmux"
    ln -sf "$DOTFILES_DIR/tmux.conf" "$HOME/.tmux.conf"
    ln -sfn "$DOTFILES_DIR/tmux" "$HOME/.tmux"
    print_success "Tmux config linked"

    # Neovim
    backup_if_exists "$HOME/.config/nvim"
    mkdir -p "$HOME/.config"
    ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    print_success "Neovim config linked"
}

# Install Tmux Plugin Manager
install_tpm() {
    print_step "Installing Tmux Plugin Manager..."

    if [[ -d "$HOME/.tmux/plugins/tpm" ]]; then
        print_warning "TPM already installed"
        return
    fi

    mkdir -p "$HOME/.tmux/plugins"
    if git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"; then
        print_success "TPM installed"
    else
        print_error "Failed to clone TPM"
    fi
}

# Install Neovim plugins
install_nvim_plugins() {
    print_step "Installing Neovim plugins..."

    if ! command -v nvim &> /dev/null; then
        print_error "Neovim not installed, skipping plugin installation"
        return
    fi

    print_step "Lazy.nvim will install plugins on first launch"
    print_success "Neovim ready"
}

# Set Zsh as default shell
set_default_shell() {
    print_step "Setting Zsh as default shell..."

    if [[ "$SHELL" == */zsh ]]; then
        print_warning "Zsh is already the default shell"
        return
    fi

    local zsh_path=$(which zsh)

    # Add zsh to allowed shells if not present
    if ! grep -q "$zsh_path" /etc/shells; then
        print_step "Adding zsh to /etc/shells (requires sudo)..."
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    print_step "Changing default shell (requires sudo)..."
    sudo chsh -s "$zsh_path" "$USER"
    print_success "Default shell set to Zsh"
    print_warning "You'll need to log out and back in for this to take effect"
}

# Main installation flow
main() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║   Dotfiles Installation Script         ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"

    detect_os
    install_homebrew
    install_cli_tools
    install_oh_my_zsh
    install_zsh_plugins
    install_asdf
    setup_symlinks
    install_tpm
    install_nvim_plugins

    echo ""
    print_step "Installation complete!"
    echo ""
    echo -e "${GREEN}Next steps:${NC}"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Open tmux and press 'prefix + I' to install tmux plugins"
    echo "  3. Open nvim - plugins will install automatically"
    echo ""

    # Ask about default shell
    read -p "Do you want to set Zsh as your default shell? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        set_default_shell
    fi

    echo ""
    print_success "All done! Enjoy your new setup! 🚀"
}

# Run main function
main
