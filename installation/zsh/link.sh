# Color definitions
WHILE='\033[0;33m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Link funtion
link() {
    if [ -f "$1" ]; then
        echo "${GREEN}Linking $1${NC}"
        ln -sf "$1" "$2"
    else
        echo "${RED}$1 does not exist${NC}"
    fi
}

# Check if the file exists, if it ask to link it, if not ask to create it
ask() {
    if [ -f "$1" ]; then
        echo "${WHITE}$1 exists${NC}"
        echo "${WHITE}Do you want to link it? (y/n)${NC}"
        read -r answer
        if [ "$answer" = "y" ]; then
            link "$1" "$2"
            # after linked the file, echo "Link success"
            echo "${GREEN}Link success${NC}"
        fi
    else
        echo "${RED}$1 does not exist${NC}"
        echo "${WHITE}Do you want to create it? (y/n)${NC}"
        read -r answer
        if [ "$answer" = "y" ]; then
            touch "$1"
            # after created the file, echo "Create success"
            echo "${GREEN}Create success${NC}"
            # after the file is created, ask to link it
            ask "$1" "$2"
        fi
    fi
}

# Link files rc.zsh and p10k.zsh to .zshrc and .p10k.zsh
ask "$HOME/.dotfiles/.config/zsh/rc.zsh" "$HOME/.zshrc"
ask "$HOME/.dotfiles/.config/zsh/p10k.zsh" "$HOME/.p10k.zsh"