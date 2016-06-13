# History
# ==================================================

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
bindkey -v


# Completion
# ==================================================
# Provides autocompletion related abilities

zstyle :compinstall filename '/home/jrpotter/.zshrc'
autoload -Uz compinit
compinit


# Environment Variables
# ==================================================

export TERM='xterm-256color'

# Added by Miniconda3 3.19.0 installer
export PATH="/home/jrpotter/.miniconda3/bin:$PATH"

# Path of powerline
export POWERLINE_PATH=/home/jrpotter/.miniconda3/lib/python3.5/site-packages/powerline


# Multiplexer
# ==================================================

if command -v tmux > /dev/null; then
    [[ ! $TERM =~ screen ]] && [ -z $TMUX ] && exec tmux
fi


# Powerline
# ==================================================

powerline-daemon -q
if [[ -r $POWERLINE_PATH/bindings/zsh/powerline.zsh ]]; then
    source $POWERLINE_PATH/bindings/zsh/powerline.zsh
fi


# Aliases
# ==================================================

alias su="su -s /bin/zsh"
