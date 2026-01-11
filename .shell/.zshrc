# Devbox Project-Local Zsh Configuration
# This file is loaded because ZDOTDIR is set to this directory.

# Source common shell environment if it exists (for basic paths/vars)
[[ -f ~/.zshenv ]] && source ~/.zshenv

# FIX: Devbox sometimes sets TERM=dumb which breaks Starship and colors.
# We force a capable terminal type.
export TERM=xterm-256color
export CLICOLOR=1

# Initialize GNU Colors (Critical for ls colors)
if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

# Fix ls colors explicitly (GNU coreutils format)
# We define these explicitly to ensure 'll' gets colors too.
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# CRITICAL: Allow variable substitution in the prompt.
# This fixes the "\[\]" raw escape code issue.
setopt PROMPT_SUBST

# Load the project-specific shell setup (Starship, aliases, etc)
# We do this FIRST to set aliases and history
if [[ -n "$DEVBOX_PROJECT_ROOT" ]]; then
  source "$DEVBOX_PROJECT_ROOT/plugins/shell/setup.sh"
fi

# Visual confirmation
echo "🚀 Virtualized Devbox Shell Active"

# Explicitly initialize Starship at the VERY END.
# This ensures its hooks are appended last and not overwritten.
if command -v starship >/dev/null 2>&1; then
  # Force Starship to recognize Zsh environment by injecting the variable directly into the PROMPT command.
  export STARSHIP_SHELL=zsh
  
  # Generate the init script
  _starship_init=$(starship init zsh --print-full-init)
  
  # INJECTION: We insert "STARSHIP_SHELL=zsh" right at the start of the prompt subshell.
  # This matches "PROMPT='$(" and replaces it with "PROMPT='$(STARSHIP_SHELL=zsh "
  _starship_init=$(echo "$_starship_init" | sed "s/PROMPT='\$(/PROMPT='\$(STARSHIP_SHELL=zsh /g")
  
  eval "$_starship_init"
fi
