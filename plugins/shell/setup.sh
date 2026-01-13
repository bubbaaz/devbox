# Shell configuration for Devbox environment

# ───────────────────────────────────────────────────────────────
# 1. Prompt Logic (Starship with Native Fallback)
# ───────────────────────────────────────────────────────────────

# Native Zsh Fallback Prompt (No external dependencies)
# Useful if starship fails or on very restricted terminals
function set_fallback_prompt() {
  # Load colors
  autoload -Uz colors && colors
  
  # Basic Git branch detection for fallback
  function git_branch_name() {
    command git symbolic-ref --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null
  }

  PROMPT="%{$fg[blue]%}%n@%m%{$reset_color%}:%{$fg[cyan]%}%~%{$reset_color%}%{$fg[magenta]%}\$(git_branch_name)%{$reset_color%} %# "
}

# Determine which Starship config to use
# Note: Starship can be unpredictable in standalone Zsh; Tmux is recommended for stability.
# If DEVBOX_NO_NERD_FONTS is set, or we can't detect a modern terminal
if [[ -n "$DEVBOX_NO_NERD_FONTS" ]]; then
  export STARSHIP_CONFIG="$DEVBOX_PROJECT_ROOT/.config/starship.simple.toml"
else
  export STARSHIP_CONFIG="$DEVBOX_PROJECT_ROOT/.config/starship.toml"
fi

# Attempt to initialize Starship
if command -v starship >/dev/null 2>&1; then
  # Note: The actual 'eval' happens in .zshrc to ensure it's the last hook
  export STARSHIP_SHELL=zsh
else
  # If starship is missing, use our robust fallback
  set_fallback_prompt
fi

# ───────────────────────────────────────────────────────────────
# 2. History Settings
# ───────────────────────────────────────────────────────────────
export HISTFILE="$DEVBOX_PROJECT_ROOT/.devbox/zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

if [ -n "$ZSH_VERSION" ]; then
  setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
fi

# ───────────────────────────────────────────────────────────────
# 3. Completion & Zsh Enhancements
# ───────────────────────────────────────────────────────────────
if [ -n "$ZSH_VERSION" ]; then
  autoload -Uz compinit && compinit
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
  zstyle ':completion:*' menu select
  setopt autocd nomatch
fi

# ───────────────────────────────────────────────────────────────
# 4. Modern Tool Integrations
# ───────────────────────────────────────────────────────────────

# Initialize Atuin (Enhanced History)
if command -v atuin >/dev/null 2>&1; then
  # Atuin uses XDG_DATA_HOME
  export XDG_DATA_HOME="$DEVBOX_PROJECT_ROOT/.local/share"
  export XDG_CACHE_HOME="$DEVBOX_PROJECT_ROOT/.cache"
  eval "$(atuin init zsh)"
fi

# ───────────────────────────────────────────────────────────────
# 5. Aliases & Colors
# ───────────────────────────────────────────────────────────────

# Forcefully override any existing aliases
unalias ls 2>/dev/null
unalias ll 2>/dev/null
unalias la 2>/dev/null
unalias l 2>/dev/null

if (command ls --color=auto / >/dev/null 2>&1); then
  alias ls='ls --color=auto'
elif (command ls -G / >/dev/null 2>&1); then
  alias ls='ls -G'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias diff='diff --color=auto'