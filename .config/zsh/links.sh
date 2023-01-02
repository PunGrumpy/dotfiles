# Link funtion
link() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}Linking $1${NC}"
        ln -s "$1" "$2"
    else
        echo -e "${RED}$1 does not exist${NC}"
    fi
}

# Link files
link ~/.config/zsh/rc.zsh ~/.zshrc

# Link powerlevel10k
link ~/.config/zsh/p10k.zsh ~/.p10k.zsh