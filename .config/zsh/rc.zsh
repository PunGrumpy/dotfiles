# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set terminal title to current directory
DISABLE_AUTO_TITLE="true"
echo -ne "\033]0;${PWD##*/}\007"

# K8s auto-complete
autoload -U +X compinit && compinit
# source <(kubectl completion zsh)

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

# ----- Bin -----
# Add ~/.local/bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# ----- Powerlevel10k -----
source_if_exists ~/.dotfiles/.config/zsh/p10k.zsh
# check ~/.powerlevel10k exists
if [ -d "$HOME/.powerlevel10k" ]; then
    source "$HOME/.powerlevel10k/powerlevel10k.zsh-theme"
fi

# ----- Plugins -----
# oh-my-zsh plugins
if [ -d "$HOME/.oh-my-zsh/plugins" ]; then
    source_if_exists ~/.oh-my-zsh/plugins/git/git.plugin.zsh
    source_if_exists ~/.oh-my-zsh/plugins/common-aliases/common-aliases.plugin.zsh
fi

# addition plugins
if [ -d "$HOME/.oh-my-zsh/custom/plugins" ]; then
    source_if_exists ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    source_if_exists ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source_if_exists ~/.oh-my-zsh/custom/plugins/zsh-completions/zsh-completions.plugin.zsh
fi

# ----- Aliases -----
source_if_exists ~/.dotfiles/.config/zsh/aliases.zsh

# ----- History -----
source_if_exists ~/.dotfiles/.config/zsh/history.zsh

# ----- Editor -----
ZSH_EDITOR="vscode"
export ZSH_EDITOR
