# History
# ==================================================

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000


# ZSH Bindings
# ==================================================

bindkey -v
bindkey -M viins '^ ' vi-cmd-mode


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

export EDITOR='nvim'
export TERM='xterm-256color'
export NVIM_DIR=$HOME/.config/nvim
export POWERLINE_PATH=/usr/lib/python3.5/site-packages/powerline


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

