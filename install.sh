#!/usr/bin/env bash
# Dotfiles link manager and bootstrap. macOS only.
#
# Usage: ./install.sh <command>
#
#   status                        Report the state of each link. Read-only.
#   link [--dry-run] [--backup]   Create or repair the links.
#   unlink                        Remove the links that point into this repo.
#   bootstrap                     Install the tools, then run "link --backup".

set -u

# Repo root, from the real location of this script.
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Link table. One row for each link: "<path in the repo>|<path below $HOME>".
# ~/.tmux is not in the table. It is a real directory that holds the TPM
# plugins. Do not link ~/.tmux or ~/.config/tmux into this repo.
LINKS=(
    "zsh/zshrc|.zshrc"
    "zsh|.zsh"
    "zsh/p10k.zsh|.p10k.zsh"
    "tmux/tmux.conf|.tmux.conf"
    "tmux/bin/tmux-project|.local/bin/tmux-project"
    "tmux/bin/tmux-agents|.local/bin/tmux-agents"
    "nvim|.config/nvim"
    "wezterm/wezterm.lua|.wezterm.lua"
    "kitty/kitty.conf|.config/kitty/kitty.conf"
)

usage() {
    cat <<'EOF'
Usage: ./install.sh <command>

  status                        Report the state of each link. Read-only.
  link [--dry-run] [--backup]   Create or repair the links.
                                --dry-run  Print the changes. Change nothing.
                                --backup   Move a real file or directory to
                                           <path>.backup.<timestamp>, then link.
  unlink                        Remove the links that point into this repo.
  bootstrap                     Install the tools, then run "link --backup".
EOF
}

say() {
    printf '%-8s %s\n' "$1" "$2"
}

# ---------------------------------------------------------------------------
# Links
# ---------------------------------------------------------------------------

# Set SRC, DST and STATE for one table row.
#   OK       DST is a link to SRC.
#   WRONG    DST is a link to a different path.
#   MISSING  DST does not exist.
#   BLOCKED  DST exists and is not a link.
#   NOSRC    SRC does not exist in the repo.
row_state() {
    SRC="$REPO/${1%%|*}"
    DST="$HOME/${1#*|}"
    if [ ! -e "$SRC" ]; then
        STATE=NOSRC
    elif [ -L "$DST" ]; then
        if [ "$(readlink "$DST")" = "$SRC" ]; then STATE=OK; else STATE=WRONG; fi
    elif [ -e "$DST" ]; then
        STATE=BLOCKED
    else
        STATE=MISSING
    fi
}

# Create or replace the link DST -> SRC with one rename.
# Do not use "ln -sf" here. On a link to a directory it makes a nested link.
make_link() {
    local src="$1" dst="$2" tmp="$2.tmp.$$"
    /bin/mkdir -p "$(dirname "$dst")" || return 1
    if /bin/ln -s "$src" "$tmp" && /bin/mv -fh "$tmp" "$dst"; then
        return 0
    fi
    if [ -L "$tmp" ]; then /bin/rm -f "$tmp"; fi
    return 1
}

cmd_status() {
    local row bad=0
    for row in "${LINKS[@]}"; do
        row_state "$row"
        case "$STATE" in
            OK)      say OK "$DST" ;;
            WRONG)   say WRONG "$DST -> $(readlink "$DST") (expected $SRC)"; bad=1 ;;
            MISSING) say MISSING "$DST (expected a link to $SRC)"; bad=1 ;;
            BLOCKED) say BLOCKED "$DST (a real file or directory is there)"; bad=1 ;;
            NOSRC)   say NOSRC "$DST (source is not in the repo: $SRC)"; bad=1 ;;
        esac
    done
    # tmux also reads ~/.config/tmux/tmux.conf. If it exists, tmux loads a
    # second config and TPM moves its plugin path to ~/.config/tmux/plugins.
    if [ -e "$HOME/.config/tmux/tmux.conf" ] || [ -L "$HOME/.config/tmux/tmux.conf" ]; then
        say ERROR "$HOME/.config/tmux/tmux.conf exists. Remove it. tmux must read only ~/.tmux.conf."
        bad=1
    fi
    return "$bad"
}

cmd_link() {
    local dry=0 backup=0 arg row changed=0 failed=0 stamp bak
    for arg in "$@"; do
        case "$arg" in
            --dry-run) dry=1 ;;
            --backup)  backup=1 ;;
            *) echo "Unknown option for link: $arg" >&2; usage >&2; return 1 ;;
        esac
    done
    stamp="$(date +%Y%m%d_%H%M%S)"

    for row in "${LINKS[@]}"; do
        row_state "$row"
        case "$STATE" in
            OK)
                continue
                ;;
            NOSRC)
                say NOSRC "$DST (source is not in the repo: $SRC)"
                failed=1
                continue
                ;;
            BLOCKED)
                if [ "$backup" -eq 0 ]; then
                    say BLOCKED "$DST (a real file or directory is there; use --backup)"
                    failed=1
                    continue
                fi
                bak="$DST.backup.$stamp"
                say BACKUP "$DST -> $bak"
                if [ "$dry" -eq 0 ] && ! /bin/mv "$DST" "$bak"; then
                    say FAILED "$DST (backup failed)"
                    failed=1
                    continue
                fi
                ;;
            WRONG)
                say RELINK "$DST -> $SRC (was $(readlink "$DST"))"
                ;;
            MISSING)
                say LINK "$DST -> $SRC"
                ;;
        esac
        if [ "$STATE" = BLOCKED ]; then say LINK "$DST -> $SRC"; fi
        changed=$((changed + 1))
        if [ "$dry" -eq 0 ] && ! make_link "$SRC" "$DST"; then
            say FAILED "$DST"
            failed=1
        fi
    done

    if [ "$dry" -eq 1 ]; then
        echo "Dry run: $changed link(s) to change. Nothing changed."
    elif [ "$changed" -eq 0 ]; then
        echo "No change."
    else
        echo "$changed link(s) changed."
    fi
    return "$failed"
}

cmd_unlink() {
    local row dst target removed=0
    for row in "${LINKS[@]}"; do
        dst="$HOME/${row#*|}"
        if [ ! -L "$dst" ]; then continue; fi
        target="$(readlink "$dst")"
        case "$target" in
            "$REPO"/*)
                if /bin/rm "$dst"; then
                    say UNLINK "$dst"
                    removed=$((removed + 1))
                fi
                ;;
            *)
                say SKIP "$dst (points outside the repo: $target)"
                ;;
        esac
    done
    echo "$removed link(s) removed."
}

# ---------------------------------------------------------------------------
# Bootstrap
#
# This part is not tested on a fresh machine. It does not ask questions and
# it does not call sudo. Each step is safe to run again.
# ---------------------------------------------------------------------------

step() {
    echo "==> $1"
}

warn() {
    echo "warning: $1" >&2
}

# Clone a git repo if the directory is not there.
clone_once() {
    local url="$1" dir="$2"
    if [ -d "$dir" ]; then
        echo "    present: $dir"
        return 0
    fi
    if git clone --depth 1 "$url" "$dir"; then
        echo "    installed: $dir"
    else
        warn "Could not clone $url"
        return 1
    fi
}

install_homebrew() {
    step "Homebrew"
    local shellenv='eval "$(/opt/homebrew/bin/brew shellenv)"'

    if ! command -v brew > /dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
        if ! NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
            warn "The Homebrew installer failed. Install Homebrew by hand (https://brew.sh), then run bootstrap again."
            return 1
        fi
    fi

    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        # Add Homebrew to the login shell. Never add the line twice.
        if ! /usr/bin/grep -qF '/opt/homebrew/bin/brew shellenv' "$HOME/.zprofile" 2> /dev/null; then
            echo "$shellenv" >> "$HOME/.zprofile"
        fi
    fi

    command -v brew > /dev/null 2>&1
}

install_packages() {
    step "Homebrew packages (Brewfile)"
    if ! brew bundle --file="$REPO/Brewfile"; then
        warn "brew bundle reported a failure. Run: brew bundle --file=$REPO/Brewfile"
    fi
}

install_oh_my_zsh() {
    step "Oh My Zsh, plugins and theme"
    local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        if ! sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; then
            warn "The Oh My Zsh installer failed."
            return 1
        fi
    fi

    # The names match the plugins list and ZSH_THEME in zsh/zshrc.
    clone_once https://github.com/Aloxaf/fzf-tab "$custom/plugins/fzf-tab"
    clone_once https://github.com/zsh-users/zsh-autosuggestions "$custom/plugins/zsh-autosuggestions"
    clone_once https://github.com/zdharma-continuum/fast-syntax-highlighting "$custom/plugins/fast-syntax-highlighting"
    clone_once https://github.com/romkatv/powerlevel10k "$custom/themes/powerlevel10k"
}

# TPM and the tmux plugins live in ~/.tmux/plugins, outside this repo.
# TPM reads the plugin list from ~/.tmux.conf, so the links must exist first.
install_tmux_plugins() {
    step "tmux plugin manager and plugins"
    local tpm="$HOME/.tmux/plugins/tpm"

    if [ ! -f "$tpm/tpm" ]; then
        /bin/mkdir -p "$HOME/.tmux/plugins"
        if ! git clone https://github.com/tmux-plugins/tpm "$tpm"; then
            warn "Could not clone TPM. Clone it to $tpm, then press prefix + I in tmux."
            return 0
        fi
    fi
    if ! "$tpm/bin/install_plugins"; then
        warn "TPM did not install the plugins. Open tmux and press prefix + I."
    fi
    return 0
}

cmd_bootstrap() {
    case "${OSTYPE:-}" in
        darwin*) ;;
        *) echo "This script supports macOS only." >&2; return 1 ;;
    esac

    install_homebrew || return 1
    install_packages
    install_oh_my_zsh

    step "Links"
    cmd_link --backup || warn "Some links failed. Run: ./install.sh status"

    install_tmux_plugins

    echo ""
    step "Bootstrap complete."
    echo "  1. Open a new terminal."
    echo "  2. Run $REPO/scripts/install-lsp-tools.sh to install the language servers."
    echo "  3. Open nvim. The plugins install on the first start."
    echo "  4. Run ./install.sh status to check the links."
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

main() {
    if [ "$#" -eq 0 ]; then
        usage
        return 1
    fi
    local cmd="$1"
    shift
    case "$cmd" in
        status)    cmd_status ;;
        link)      cmd_link "$@" ;;
        unlink)    cmd_unlink ;;
        bootstrap) cmd_bootstrap ;;
        -h|--help|help) usage ;;
        *) echo "Unknown command: $cmd" >&2; usage >&2; return 1 ;;
    esac
}

main "$@"
