# Dotfiles

Personal configuration for zsh (Oh My Zsh + Powerlevel10k), tmux, Neovim (LazyVim), WezTerm and kitty, plus a few helper scripts. macOS on Apple Silicon only.

## Layout

One directory per tool. The repo root holds only repo-level files.

```
dotfiles/
├── install.sh               # link manager and bootstrap
├── Brewfile                 # Homebrew packages that the configs call
├── zsh/
│   ├── zshrc                # main rc file
│   ├── p10k.zsh             # Powerlevel10k prompt (written by `p10k configure`)
│   ├── aliases.zsh
│   ├── functions.zsh
│   ├── git.zsh              # fzf git helpers
│   └── tools.zsh            # fzf, atuin and asdf setup
├── tmux/
│   ├── tmux.conf
│   └── bin/
│       ├── tmux-agents      # dashboard of AI agent panes
│       └── tmux-project     # project and session creator
├── nvim/                    # LazyVim config
│   ├── init.lua
│   ├── lazy-lock.json       # written by lazy.nvim
│   ├── lazyvim.json         # written by LazyVim
│   ├── lsp/                 # native LSP server configs
│   └── lua/
│       ├── config/
│       └── plugins/
├── wezterm/
│   └── wezterm.lua
├── kitty/
│   └── kitty.conf
└── scripts/
    └── install-lsp-tools.sh # run by hand, never linked
```

## Links

`install.sh` holds a table of links. Each link is an absolute symlink from the home directory into this repo.

| Path in the repo | Link in the home directory |
|---|---|
| `zsh/zshrc` | `~/.zshrc` |
| `zsh/` | `~/.zsh` |
| `zsh/p10k.zsh` | `~/.p10k.zsh` |
| `tmux/tmux.conf` | `~/.tmux.conf` |
| `tmux/bin/tmux-project` | `~/.local/bin/tmux-project` |
| `tmux/bin/tmux-agents` | `~/.local/bin/tmux-agents` |
| `nvim/` | `~/.config/nvim` |
| `wezterm/wezterm.lua` | `~/.wezterm.lua` |
| `kitty/kitty.conf` | `~/.config/kitty/kitty.conf` |

`scripts/` is not linked. The alias `lspup` runs `scripts/install-lsp-tools.sh` through `$DOTFILES`, which `zsh/zshrc` sets from its own real path. The repo can live in any directory.

## Install

```bash
git clone https://github.com/pbpeterson/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh bootstrap
```

Commands of `install.sh`:

| Command | Effect |
|---|---|
| `./install.sh status` | Reports each link: `OK`, `WRONG`, `MISSING`, `BLOCKED` or `NOSRC`. Read-only. Exit code 0 only when all links are `OK`. |
| `./install.sh link` | Creates or repairs the links. It does not replace a real file or directory. |
| `./install.sh link --dry-run` | Prints the changes and changes nothing. |
| `./install.sh link --backup` | Moves a real file or directory to `<path>.backup.<timestamp>`, then links. |
| `./install.sh unlink` | Removes the links that point into this repo. |
| `./install.sh bootstrap` | Installs Homebrew, the `Brewfile` packages, Oh My Zsh with its plugins and theme, and the tmux plugins. Then it runs `link --backup`. |

Notes on `bootstrap`:

- It is **not tested on a fresh machine**. Read it before you run it.
- It does not ask questions and it does not call `sudo`. If the Homebrew installer needs a password, install Homebrew by hand and run `bootstrap` again.
- kitty is not in the `Brewfile`. Install it yourself.
- After `bootstrap`, run `scripts/install-lsp-tools.sh` to install the language servers, the formatters and the `js-debug` adapter.

If you only want the links, install the packages yourself and run `./install.sh link`.

## Switching branches

The links in the home directory point into the work tree of this repo. If you check out a commit with a different layout, some links point at paths that do not exist. New shells then start with no rc file. Open shells and the tmux server keep working.

- After you check out a commit with this layout, run `./install.sh link`.
- Do not run the `install.sh` of an older commit to repair the links. Before this layout it was a full install script with no subcommands.
- On the machine where the layout changed, a repair script exists: `~/.local/state/dotfiles-reorg/fix-links.sh`. It points each link at the path that exists in the checked-out tree, for the old layout and for this one.

## zsh

- `zsh/zshrc` loads Oh My Zsh with the plugins `fzf-tab`, `git`, `zsh-autosuggestions` and `fast-syntax-highlighting`, and the Powerlevel10k theme.
- `zsh/zshrc` names each module file that it sources: `aliases.zsh`, `functions.zsh`, `tools.zsh`, `git.zsh`. Do not source `~/.zsh/*.zsh` by glob. That would also load `p10k.zsh` and `zshrc`.
- Completion files come from Homebrew (`$HOMEBREW_PREFIX/share/zsh/site-functions`). This repo tracks none.
- Secrets and machine-specific settings go in `~/.zshrc.local`. The file is not in this repo. `zsh/zshrc` sources it if it exists.
- Caches go to `~/.cache/zsh`. The history goes to `~/.local/share/zsh`.

Key bindings from fzf: `Ctrl+R` history search, `Ctrl+T` file search, `Alt+C` directory jump.

| Command | Effect |
|---|---|
| `z` | Jump to a directory (zoxide). `cd` is an alias for `z`. |
| `zz` | Fuzzy directory jump (zoxide + fzf) |
| `pf` | Fuzzy process killer |
| `timezsh` | Benchmark the zsh startup time |
| `helpme` | Show a list of functions and aliases |
| `codeshot` | Render code to an image with silicon |
| `vpn-up`, `vpn-log`, `vpn-down` | Start OpenVPN in the background, follow its log, stop it |
| `fbr`, `fco`, `fshow`, `fstash` | Fuzzy git branch, commit, log and stash browsers |
| `gadd`, `gdiff`, `greset` | Fuzzy git add, diff and unstage |
| `tp` | Run `tmux-project` |
| `e` | Open Neovim |
| `nv` | Open Neovim with the `nvim_native` config |
| `lspup` | Run `scripts/install-lsp-tools.sh` |

## tmux

- Prefix: `C-s`. Theme: Kanagawa colours, written in `tmux/tmux.conf`. Status bar at the top.
- Plugins: `tpm`, `tmux-fzf`, `tmux-cpu`, `tmux-battery`.
- The plugins live in `~/.tmux/plugins`, outside this repo. `~/.tmux` is a real directory, not a link. TPM installs and updates the plugins there, so the repo stays clean. `tmux/plugins/` is in `.gitignore` as a guard.
- tmux must read only `~/.tmux.conf`. If `~/.config/tmux/tmux.conf` exists, tmux loads a second config and TPM moves its plugin path. `./install.sh status` reports that as an error.

| Key | Effect |
|---|---|
| `prefix + r`, `Alt+r` | Reload the config |
| `prefix + c` | New window, with a name prompt |
| `Alt+t` | New window |
| `Alt+1` to `Alt+9` | Go to a window |
| `Alt+{`, `Alt+}` | Previous and next window |
| `Ctrl+Shift+Left`, `Ctrl+Shift+Right` | Move the window |
| `prefix + \|`, `prefix + -` | Split the pane, with a title prompt |
| `prefix + h/j/k/l`, `Alt+h/j/k/l` | Go to a pane |
| `prefix + H/J/K/L` | Resize the pane |
| `prefix + x`, `prefix + X`, `Alt+w` | Close the pane, the window, the pane with no prompt |
| `prefix + y` | Send input to all panes of the window |
| `prefix + g` | lazygit popup |
| `prefix + G` | Scratch session popup |
| `prefix + a` | Agent dashboard (`tmux-agents`) |
| `prefix + n` | New project session (`tmux-project`) |
| `prefix + S`, `prefix + w` | Choose a session |
| `prefix + N`, `prefix + R` | New session, rename session |
| `prefix + v`, `prefix + /` | Copy mode, copy mode with search |
| `prefix + F` | tmux-fzf menu |
| `prefix + I`, `prefix + U` | Install and update the plugins (TPM) |

## Neovim

- LazyVim with the extras listed in `nvim/lazyvim.json`. Colour scheme: Kanagawa.
- Native LSP (`vim.lsp.enable`), no mason. Server configs are in `nvim/lsp/`: `vtsls`, `denols`, `tailwindcss`, `lua_ls`, `jsonls`, `marksman`. `scripts/install-lsp-tools.sh` installs the servers.
- Plugin specs are in `nvim/lua/plugins/`: fff picker, snacks, conform, blink.cmp, nvim-lint, nvim-dap, image.nvim, nvim-silicon, nvim-spider, zen-mode, twilight.
- `nvim/lua/plugins/lsp/autotag.lua` is **not loaded**. lazy.nvim imports only the files directly in `nvim/lua/plugins/`.
- `nvim/LICENSE` is the Apache 2.0 licence of the LazyVim starter, from which this config derives.

## Terminals

- `wezterm/wezterm.lua` and `kitty/kitty.conf` hold the same settings: JetBrainsMono Nerd Font, size 18, Kanagawa colours. Keep them in sync by hand.
- kitty reloads its config when the file changes.

## Files that programs rewrite

Programs write into this repo through the links. Expect diffs in these files:

- `nvim/lazy-lock.json` — lazy.nvim, on each plugin update.
- `nvim/lazyvim.json` — LazyVim, when the extras or the news state change.
- `zsh/p10k.zsh` — `p10k configure`.
- `zsh/zshrc` — some installers add lines at the end. Review them before you commit.

## Files outside this repo that the configs expect

- `~/Library/Application Support/silicon/themes/kanagawa-wave.tmTheme` — theme for `codeshot` and nvim-silicon.
- `~/Library/LaunchAgents/com.caffeinate.plist` — used by the aliases `caf-start`, `caf-stop` and `caf-status`.
- `~/.config/nvim_native/` — second Neovim config, used by the alias `nv`.
- `~/.zshrc.local` — secrets and local settings.

## Troubleshooting

- Links: `./install.sh status`, then `./install.sh link`.
- tmux plugins missing: press `prefix + I`.
- Neovim plugins: open nvim and run `:Lazy sync`.
- zsh plugin not found: run `./install.sh bootstrap`, or clone the plugin into `~/.oh-my-zsh/custom/plugins`.

## License

MIT License - Feel free to use and modify as needed.

## Credits

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [LazyVim](https://www.lazyvim.org/)
- [Kanagawa](https://github.com/rebelot/kanagawa.nvim)
- [TPM](https://github.com/tmux-plugins/tpm)
