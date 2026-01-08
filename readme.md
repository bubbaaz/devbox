Setup Devbox

# Devbox + Direnv + Atuin Setup Guide

### 1. Install System Dependencies

Run this on the new Mac to install the "engines" that manage your environments:
brew install devbox direnv atuin

### 2. Configure Global Shell (~/.zshrc)

Add these EXACT lines to the absolute bottom of your ~/.zshrc file.
The order is critical: Direnv must load the path before Atuin initializes.

# --- Global Hooks ---

eval "$(direnv hook zsh)"
eval "$(atuin init zsh)"

### 3. Initialize the Project Folder

Inside your project directory, create/update these two files:

--- File: devbox.json ---
{
"packages": [
"neovim@latest",
"atuin@latest",
"lolcat@latest"
],
"shell": {
"init_hook": [
"if [ -n "$ZSH_VERSION" ]; then eval "$(atuin init zsh)"; fi",
"export XDG_CONFIG_HOME="$PWD/.config/nvim"",
"echo "✨ Devbox Environment Loaded!" | lolcat"
]
}
}

--- File: .envrc ---

# Run this command to generate it automatically:

# devbox generate direnv

eval "$(devbox generate direnv --print-envrc)"

### 4. Activate Automation

Run this once inside the project folder to link everything together:
devbox generate direnv && direnv allow

### 5. Verification

1. Exit and return to the folder: `cd .. && cd -`
2. Check Path: `which nvim` (Should point to .devbox/nix/profile/...)
3. Check UI: Press `Ctrl + R` (Should open Atuin search)
