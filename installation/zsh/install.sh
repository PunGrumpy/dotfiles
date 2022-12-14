# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Welcome message
# echo "${GREEN}Welcome to zsh installation script${NC}"
echo "Welcome to zsh installation script" | pv -qL 10 | lolcat

# Check power10kline is installed, if not ask to install it
if [ -f ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme ]; then
    echo "${GREEN}powerlevel10k is installed${NC}"
else
    echo "${RED}powerlevel10k is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
    fi
fi

# Check oh-my-zsh is installed, if not ask to install it
if [ -d ~/.oh-my-zsh ]; then
    echo "${GREEN}oh-my-zsh is installed${NC}"
else
    echo "${RED}oh-my-zsh is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        exit
    fi
fi

# Check zsh-autosuggestions is installed, if not ask to install it
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
    echo "${GREEN}zsh-autosuggestions is installed${NC}"
else
    echo "${RED}zsh-autosuggestions is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi
fi

# Check zsh-syntax-highlighting is installed, if not ask to install it
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
    echo "${GREEN}zsh-syntax-highlighting is installed${NC}"
else
    echo "${RED}zsh-syntax-highlighting is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
fi

# Check zsh-completions is installed, if not ask to install it
if [ -d ~/.oh-my-zsh/custom/plugins/zsh-completions ]; then
    echo "${GREEN}zsh-completions is installed${NC}"
else
    echo "${RED}zsh-completions is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    fi

# Ask to ./links.sh
echo "${WHITE}Do you want to link files? (y/n)${NC}"
read -r answer
# Check current directory before running ./link.sh
if [ "$answer" = "y" ]; then
    ./link.sh
else 
    echo "${RED}Linking files is skipped${NC}"
    echo "${RED}Do you want to link file, you can run ./link.sh${NC}"
fi
