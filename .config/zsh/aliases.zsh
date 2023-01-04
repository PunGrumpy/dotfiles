# ----- Aliases -----
# LS
if command -v exa >/dev/null 2>&1; then
    alias ls='exa'
    alias la='exa -a'
    alias ll='exa -l --git --group'
    alias lla='exa -la --git --group'
    alias lt='exa -T' 
else
    alias ls='ls --color=auto'
    alias la='ls -a --color=auto'
    alias ll='ls -l --color=auto'
    alias lla='ls -la --color=auto'
fi

# Git
alias g='git'

# NeoVim
alias vim='nvim'

# History
alias h='history'
alias hc='history -c'
alias hg='history | grep'

