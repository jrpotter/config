# History
# ==================================================

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

# ZSH Bindings
# ==================================================

bindkey -v
bindkey -M viins '^b' backward-word
bindkey -M viins '^w' forward-word
KEYTIMEOUT=1

# Default to command line mode
# zle-line-init() { zle -K 'vicmd' }
# zle -N zle-line-init

# Completion
# ==================================================
# Provides autocompletion related abilities

zstyle :compinstall filename '/home/jrpotter/.zshrc'
autoload -Uz compinit
compinit

eval "$(dircolors -b)"

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Aliases
# ==================================================

alias su='su -s /bin/zsh'
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias tmx='tmux new-session -A -s'
alias alert='notify-send --urgency=low -i \
    "$([ $? = 0 ] && echo terminal || echo error)" \
    "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Environment Variables
# ==================================================

export TERM='xterm-256color'

export EDITOR='nvim'
export P4DIFF='nvim -d'
export NVIM_DIR=$HOME/.config/nvim
export TMUX_DIR=$HOME/.config/tmux

export CONDA_PATH=$HOME/Documents/miniconda3
export POWERLINE_PATH=$CONDA_PATH/lib/python3.5/site-packages/powerline
export PATH=$CONDA_PATH/bin:$HOME/.local/bin:$PATH

# Multiplexer
# ==================================================

set -o ignoreeof
if command -v tmux > /dev/null; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && tmx main
fi

# Powerline
# ==================================================

powerline-daemon -q
if [[ -r $POWERLINE_PATH/bindings/zsh/powerline.zsh ]]; then
    source $POWERLINE_PATH/bindings/zsh/powerline.zsh
fi

# FZF (Fuzzy Finder)
# ==================================================

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
