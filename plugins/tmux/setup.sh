# ───────────────────────────────────────────────────────────────
# Make tmux config project-local (reproducible & isolated)
# ───────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$PWD/.config"

# Create required directory if it doesn't exist
mkdir -p "$XDG_CONFIG_HOME/tmux"

# Copy the tmux.conf from the plugin directory to the config directory
# This ensures tmux picks it up via XDG_CONFIG_HOME
cp "$DEVBOX_PROJECT_ROOT/plugins/tmux/tmux.conf" "$XDG_CONFIG_HOME/tmux/tmux.conf"
