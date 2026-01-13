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
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'

# CRITICAL: Allow variable substitution in the prompt.
setopt PROMPT_SUBST

# Load the project-specific shell setup (Starship config, aliases, etc)
if [[ -n "$DEVBOX_PROJECT_ROOT" ]]; then
  source "$DEVBOX_PROJECT_ROOT/plugins/shell/setup.sh"
fi

# Explicitly initialize Starship at the VERY END.
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_SHELL=zsh
  
  # Try to generate init, if it fails, use fallback
  if _starship_init=$(starship init zsh --print-full-init 2>/dev/null); then
     # Injection for shell consistency
     _starship_init=$(echo "$_starship_init" | sed "s/PROMPT='\$(/PROMPT='\$(STARSHIP_SHELL=zsh /g")
     eval "$_starship_init"
  else
     # Binary exists but execution failed
     [[ -f "$DEVBOX_PROJECT_ROOT/plugins/shell/setup.sh" ]] && set_fallback_prompt
  fi
else
  # Starship binary not found, setup.sh already called set_fallback_prompt
  # but we ensure it here just in case.
  [[ "$(type -w set_fallback_prompt 2>/dev/null)" == *"function"* ]] && set_fallback_prompt
fi

# Visual confirmation (Unless in tmux or subshell to avoid clutter)
if [[ -z "$TMUX" ]]; then
  echo "🚀 Virtualized Devbox Shell Active"
fi