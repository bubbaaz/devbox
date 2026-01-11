# Portable Rust & NeoVim Environment

This project uses [Devbox](https://www.jetpack.io/devbox) to create a **fully isolated, reproducible, and portable** development environment.

It goes beyond standard package installation by virtualizing your entire shell experience. When you enter this environment, you get a custom Zsh, a premium Starship prompt, and a pre-configured NeoVim IDE—all without touching your host machine's configuration files (`~/.zshrc`, `~/.config/nvim`, etc.).

---

## 🏗 Architecture

The environment is built on a "Provisioning vs. Configuration" split, ensuring that tools are not just installed, but correctly set up for isolation.

```mermaid
graph TD
    subgraph "Provisioning (devbox.json)"
        Devbox[Devbox] -->|Installs| Core[Core Tools]
        Core --> Rust[Rust Toolchain\n(rustc, cargo, ra)]
        Core --> ShellPkg[Shell Utils\n(zsh, starship, coreutils)]
        Core --> Editor[Editor\n(neovim, lua, etc.)]
        
        Devbox -->|Includes| ShellPlugin[plugins/shell/]
        Devbox -->|Includes| NvimPlugin[plugins/nvim/]
    end

    subgraph "Shell Isolation (plugins/shell/)"
        ShellPlugin -->|Sets| ZDOTDIR["ZDOTDIR=$PWD/.shell"]
        ZDOTDIR -->|Loads| LocalRc[.shell/.zshrc]
        LocalRc -->|Sources| SetupSh[plugins/shell/setup.sh]
        SetupSh -->|Configures| Starship[Starship Prompt]
        SetupSh -->|Configures| Aliases[Colors & Aliases]
    end

    subgraph "Editor Isolation (plugins/nvim/)"
        NvimPlugin -->|Sets| XDG[XDG_CONFIG_HOME]
        XDG -->|Points to| LocalConfig[.config/nvim/]
        LocalConfig -->|Bootstraps| LazyVim[LazyVim Distro]
    end
```

### Key Technologies
1.  **Devbox**: Manages binary packages via Nix.
2.  **ZDOTDIR Isolation**: We override the `ZDOTDIR` environment variable to point to `.shell/`. This forces Zsh to ignore your global `~/.zshrc` and load ours instead, granting us total control over the shell environment.
3.  **Project-Local Home**: NeoVim and other tools are configured to see this directory (specifically `.config` and `.local`) as their "home", preventing conflicts with your system settings.

---

## 🚀 Features

### 🦀 Rust Toolchain
- **Full Stack**: Includes `rustc`, `cargo`, and `rust-analyzer` (latest stable).
- **Zero Config**: Ready to compile and analyze code immediately.

### 🐚 The "Premium" Shell
A fully configured Zsh environment that looks and feels the same on macOS, Linux, or WSL.
- **Starship Prompt**: A high-performance, information-rich prompt showing git status, Rust version, and package info.
- **Smart Autocomplete**: Case-insensitive matching, menu selection (`TAB` to cycle), and path completion.
- **Visuals**: `ls`, `grep`, and `diff` are aliased with proper color flags outputting standard GNU/BSD colors.
- **Isolation**: Your aliases, history, and variables stay in this folder. `exit` returns you to your pristine host shell.

### 📝 NeoVim IDE
- **LazyVim Base**: A heavily optimized configuration framework.
- **Self-Contained**: Plugins are installed to `.local/share/nvim` inside this project.
- **Headless Bootstrap**: Automatically installs itself on the first run.

---

## 🛠 Usage

### 1. Enter the Environment
Running `devbox shell` is the **only** command you need. It handles the "handoff" from your system shell to our isolated Zsh.

```bash
# Enter the magic zone
devbox shell
```

> **Note**: You will see a "🚀 Virtualized Devbox Shell Active" message confirmation.

### 2. Work on Code
Once inside, you have access to all tools:

```bash
# Run Rust code
cargo run

# Edit files (using the isolated NeoVim)
nvim main.rs

# Use the shell
ls -la  # Colored output
```

### 3. Exit
To return to your normal host system:

```bash
exit
```

---

## 🔧 Troubleshooting

### "My prompt didn't load!"
If you see a plain prompt or missing colors, it usually means the terminal was detected as "dumb" or the initialization hook was skipped.
*   **Fix**: Run `exit` and `devbox shell` again. We explicitly force `TERM=xterm-256color` and inject the prompt string to prevent this.

### "Where is my history?"
Shell history is saved to `.devbox/zsh_history`. It is specific to this project, so commands you run here won't clutter your main history.

---

## ⚡ Reproducing on Another Machine

This environment is designed to be 100% portable. To set it up on a new laptop or server:

1.  **Install Devbox**:
    ```bash
    curl -fsSL https://get.jetpack.io/devbox | bash
    ```

2.  **Clone this Repository**:
    ```bash
    git clone <your-repo-url> devbox-rust
    cd devbox-rust
    ```

3.  **Launch**:
    ```bash
    devbox shell
    ```

**That's it.** Devbox will automatically download the pinned versions of Rust, NeoVim, Zsh, and Starship. You will be dropped into the exact same shell environment with the exact same configuration as your main machine.
