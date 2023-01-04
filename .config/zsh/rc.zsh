# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
source_if_exists ~/.config/zsh/aliases.zsh

# ----- Bin -----
# Add ~/.local/bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# ----- History -----
source_if_exists ~/.dotfiles/.config/zsh/history.zsh

# ----- Powerlevel10k -----
# path p10k.zsh
# link p10k.zsh to ~/.p10k.zsh
source_if_exists ~/.dotfiles/.config/zsh/p10k.zsh
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
    source_if_exists ~/.oh-my-zsh/custom/plugins/zsh-completions/zsh-completions.plugin.zsh
fi

# ----- Zsh-editor -----
ZSH_EDITOR="vscode"
export ZSH_EDITOR