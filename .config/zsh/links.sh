# Color definitions
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
        echo "${GREEN}$1 exists${NC}"
        echo "${GREEN}Do you want to link it? (y/n)${NC}"
        read -r answer
        if [ "$answer" = "y" ]; then
            link "$1" "$2"
        fi
    else
        echo "${RED}$1 does not exist${NC}"
        echo "${RED}Do you want to create it? (y/n)${NC}"
        read -r answer
        if [ "$answer" = "y" ]; then
            touch "$1"
        fi
    fi
}

# Link files rc.zsh and p10k.zsh to .zshrc and .p10k.zsh
ask "$HOME/.config/zsh/rc.zsh" "$HOME/.zshrc"
ask "$HOME/.config/zsh/p10k.zsh" "$HOME/.p10k.zsh"