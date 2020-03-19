# .bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin" ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
if ! [[ "$PATH" =~ "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi
if ! [[ "$PATH" =~ "$HOME/.cargo/bin" ]]; then
    export PATH="$HOME/.cargo/bin:$PATH"
fi

export GOPATH=$HOME/Dropbox/Projects/go

# User specific environment and startup programs

export EDITOR=vim
export VISUAL=vim
export CLICOLOR=1

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

alias la='ls -la'
alias rm='rm -i'
alias grep='grep --color'
alias grepc='grep --color=always'
alias less='less -r'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

