# Link funtion
link() {
    if [ -f "$1" ]; then
        echo "${GREEN}Linking $1${NC}"
        ln -sf "$1" "$2"
    else
        echo "${RED}$1 does not exist${NC}"
    fi
}

# Link files
link ~/.config/zsh/rc.zsh ~/.zshrc

# Link powerlevel10k
link ~/.config/zsh/p10k.zsh ~/.p10k.zsh