# ───────────────────────────────────────────────────────────────
# Make Neovim config & data project-local (reproducible & isolated)
# ───────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="$PWD/.config"
export XDG_DATA_HOME="$PWD/.local/share"
export XDG_CACHE_HOME="$PWD/.cache"

# Create required directories if they don't exist
mkdir -p "$XDG_CONFIG_HOME/nvim"
mkdir -p "$XDG_DATA_HOME/nvim"
mkdir -p "$XDG_CACHE_HOME/nvim"

# ───────────────────────────────────────────────────────────────
# ONE-TIME LAZYVIM SETUP: Only run if init.lua doesn't exist yet
# This prevents overwriting your custom config on every shell start
# ───────────────────────────────────────────────────────────────
if [ ! -f "$XDG_CONFIG_HOME/nvim/init.lua" ]; then
  echo "Setting up LazyVim starter for the first time..."
  
  # Copy the init.lua from the plugin directory to the config directory
  # The plugin directory is relative to where this script is found, but we need to find it relative to project
  # Since this script is sourced, we can try to locate the original init.lua
  # For local plugins, we can assume it's in the same dir as this script or passed in
  
  # A robust way is to source it directly or cat it if we know the path.
  # However, in Devbox plugins, best practice is often to 'cp' from the plugin source location if possible,
  # or just embed the content if we want to be 100% sure. 
  # But the goal here is to split it out. 
  # Let's assume the user wants the file copied.
  
  # We will use 'cat' and a variable or similar if we can find the path.
  # BUT, a simpler way for this refactor is to just cat the specific file relative to the project if known, 
  # OR, since we are in devbox, we can keep the 'cat' approach but read from the `plugins/nvim/init.lua` 
  # which is now checked in.
  
  cp "plugins/nvim/init.lua" "$XDG_CONFIG_HOME/nvim/init.lua"
  
  echo "LazyVim starter created! Run 'nvim' to finish first-time install"
else
  echo "Existing Neovim config found — skipping overwrite"
fi
