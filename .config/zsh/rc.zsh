# check file exists
source_if_exists() {
    if [ -f "$1" ]; then
        source "$1"
    fi
}

# ----- Brew shellenv -----
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

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
    alias la='ls -a'
    alias ll='ls -l'
    alias lla='ls -la'
    alias lt='ls -T'
fi
# Git
alias g='git'
# Vim
alias v='vim'

# ----- Bin -----
# Add ~/.local/bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# ----- History -----
source_if_exists ~/.config/zsh/history.zsh

# ----- Powerlevel10k -----
# path p10k.zsh
# link p10k.zsh to ~/.p10k.zsh
source_if_exists ~/.config/zsh/p10k.zsh
# check ~/.powerlevel10k exists
if [ -d "$HOME/.powerlevel10k" ]; then
    source "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
fi

# ----- Plugins -----
# check plugins directory exists
if [ -d "$HOME/.oh-my-zsh/custom/plugins" ]; then
    # path plugins
    source_if_exists ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source_if_exists ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ----- Zsh-editor -----
ZSH_EDITOR="vscode"
export ZSH_EDITOR
