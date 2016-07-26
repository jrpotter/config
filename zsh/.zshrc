# History
# ==================================================

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000


# ZSH Bindings
# ==================================================

bindkey -v
bindkey -M viins '^ ' vi-cmd-mode

# Maintain mode between commands
accept-line() { prev_mode=$KEYMAP; zle .accept-line }
zle-line-init() { zle -K ${prev_mode:-viins} }
zle -N accept-line
zle -N zle-line-init


# Completion
# ==================================================
# Provides autocompletion related abilities

zstyle :compinstall filename '/home/jrpotter/.zshrc'
autoload -Uz compinit
compinit


# Environment Variables
# ==================================================

alias su='su -s /bin/zsh'
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias alert='notify-send --urgency=low -i \
    "$([ $? = 0 ] && echo terminal || echo error)" \
    "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export EDITOR='nvim'
export TERM='xterm-256color'
export NVIM_DIR=$HOME/.config/nvim
export TMUX_DIR=$HOME/.config/tmux
export POWERLINE_PATH=/usr/lib/python3.5/site-packages/powerline

set -o ignoreeof


# Multiplexer
# ==================================================

if command -v tmux > /dev/null; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux new-session -A -s main
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

