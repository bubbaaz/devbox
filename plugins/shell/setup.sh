# Shell configuration for Devbox environment
export STARSHIP_CONFIG="$DEVBOX_PROJECT_ROOT/.config/starship.toml"

# Forcefully override any existing aliases that might interfere
unalias ls 2>/dev/null
unalias ll 2>/dev/null
unalias la 2>/dev/null
unalias l 2>/dev/null

# Detect if we are in Zsh
if [ -n "$ZSH_VERSION" ]; then
  # Only initialize if starship is in the path
  if command -v starship >/dev/null 2>&1; then
    # Starship init moved to .zshrc to ensure hook precedence
    
    # Standard Zsh enhancements
    autoload -Uz compinit && compinit
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
    zstyle ':completion:*' menu select
    setopt autocd nomatch
    
    # History settings (local to project)
    export HISTFILE="$DEVBOX_PROJECT_ROOT/.devbox/zsh_history"
    export HISTSIZE=10000
    export SAVEHIST=10000
    setopt APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
  fi
elif [ -n "$BASH_VERSION" ]; then
  if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
  fi
fi

# Color aliases
if (command ls --color=auto / >/dev/null 2>&1); then
  alias ls='ls --color=auto'
elif (command ls -G / >/dev/null 2>&1); then
  alias ls='ls -G'
fi

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
