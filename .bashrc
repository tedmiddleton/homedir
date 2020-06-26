[[ -f /etc/bashrc ]] && source /etc/bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# User specific aliases and functions

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
#if ! [[ "$PATH" =~ "$HOME/bin" ]]; then
#    export PATH="$HOME/bin:$PATH"
#fi
if ! [[ "$PATH" =~ "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

export GOPATH=$HOME/Dropbox/Projects/go

# User specific environment and startup programs

export EDITOR=vim
export VISUAL=vim
export CLICOLOR=1

alias la='ls -la'
alias rm='rm -i'
alias grep='grep --color'
alias grepc='grep --color=always'
alias less='less -r'

# .inputrc will do this, but later, and key-bindings.bash depends on this
set -o vi
fzf_file=/usr/share/fzf/shell/key-bindings.bash
[[ -f ${fzf_file} ]] && source ${fzf_file}


complete -C /home/tedm/.local/bin/terraform terraform
