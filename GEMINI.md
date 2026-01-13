# GEMINI.md - Context & Instructions

## Project Overview

This directory contains a **portable, virtualized development environment** managed by [Devbox](https://www.jetpack.io/devbox). It is designed to provide a completely isolated toolchain for Rust development, complete with a pre-configured shell (Zsh + Starship) and editor (NeoVim + LazyVim), without modifying the user's global system configuration.

**Primary Goal**: To offer a "drop-in" coding environment where running `devbox shell` instantly provides all necessary tools and configurations.

---

## 🏗 Architecture

The project uses a "Provisioning vs. Configuration" pattern to achieve isolation:

1.  **Provisioning (`devbox.json`)**:
    *   Installs binaries via Nix (Rust, NeoVim, Node.js, Python, etc.).
    *   Injects environment variables to redirect configuration paths.
    *   Includes local plugins from the `plugins/` directory.

2.  **Shell Isolation (`plugins/shell/` & `.shell/`)**:
    *   Sets `ZDOTDIR=$DEVBOX_PROJECT_ROOT/.shell`.
    *   This forces Zsh to ignore `~/.zshrc` and load `.shell/.zshrc` instead.
    *   Local history is saved to `.devbox/zsh_history`.
    *   Configures `starship` prompt with a project-specific config.

3.  **Editor Isolation (`plugins/nvim/`)**:
    *   Sets `XDG_CONFIG_HOME`, `XDG_DATA_HOME`, and `XDG_CACHE_HOME` to local directories within the project (`.config/`, `.local/`, `.cache/`).
    *   Bootstraps a LazyVim configuration automatically on first run.

4.  **Terminal Multiplexer Isolation (`plugins/tmux/`)**:
    *   Sets up a project-local `tmux.conf`.
    *   Links configuration to `.config/tmux/tmux.conf` via `XDG_CONFIG_HOME`.

---

## 🔑 Key Files

*   **`devbox.json`**: The central manifest. Lists packages (e.g., `rustc`, `cargo`, `neovim`, `bat`, `tmux`) and includes plugins.
*   **`.shell/.zshrc`**: The entry point for the isolated shell. It sets up the terminal colors and sources the setup script.
*   **`plugins/shell/setup.sh`**: Defines aliases (`ls`, `grep`), history settings, and Starship initialization.
*   **`plugins/nvim/setup.sh`**: Redirects Neovim's config paths to the project folder and bootstraps `init.lua` if missing.
*   **`plugins/tmux/tmux.conf`**: The project-specific tmux configuration.
*   **`.config/starship.toml`**: The configuration for the shell prompt.

---

## 🚀 Usage

The entire environment is controlled via the `devbox` CLI.

### Entering the Environment
```bash
devbox shell
```
*   This spawns a new Zsh shell.
*   You should see "🚀 Virtualized Devbox Shell Active".
*   All tools (Rust, Nvim, etc.) are now available in your PATH.

### Working with Code
*   **Multiplexer**: Run `tmux` to enter the project-local tmux session. This is highly recommended as the **Starship prompt is most stable within Tmux**.
*   **Build/Run**: `cargo run` / `cargo build`
*   **Edit**: `nvim <file>` (Uses the isolated LazyVim config)
*   **Shell**: Standard Zsh commands, with syntax highlighting and autosuggestions enabled.

### Exiting
```bash
exit
```
*   Returns you to your host shell. Cleanly unloads all environment overrides.

---

## 🛠 Development Conventions

*   **Package Management**: All tools must be added via `devbox add <package>` (or manually editing `devbox.json`), **never** installed globally or via system package managers (apt, brew, etc.) for this project context.
*   **Configuration**:
    *   Edit `.shell/.zshrc` or `plugins/shell/setup.sh` for shell changes.
    *   Edit `.config/nvim/` for editor changes.
*   **Persistence**: Note that while the *configuration* is checked into git, the *installed binaries* are managed by Nix/Devbox in the `.devbox` directory (which is ignored).
