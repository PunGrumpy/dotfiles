# Installation script for Homebrew
# https://brew.sh/

# Color
WHITE='\033[0;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Before install Homebrew, check git, curl, if not installed ask to install it
if test ! $(which git)
then
    echo "${RED}git is not installed, do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        sudo apt-get install git
        echo "${GREEN}git installed${NC}"
    fi
else
    echo "${GREEN}git is installed${NC}"
fi

if test ! $(which curl)
then
    echo "${RED}curl is not installed, do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        sudo apt-get install curl
        echo "${GREEN}curl installed${NC}"
    fi
else
    echo "${GREEN}curl is installed${NC}"
fi

# Check for Homebrew
if test ! $(which brew)
then
    # ask before install
    echo "${RED}Homebrew is not installed, do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        # Install the correct homebrew for each OS type
        if test "$(uname)" = "Darwin"
        then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            echo "${GREEN}Homebrew installed${NC}"
        elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
        then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
            echo "${GREEN}Homebrew installed${NC}"
        fi
    fi       
else
    echo "${GREEN}Homebrew is installed${NC}"
fi

# Check os and then Ask to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc
if test "$(uname)" = "Darwin"
then
    echo "${WHITE}Do you want to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bashrc
        echo "${GREEN}eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc successfully${NC}"
    else
        echo "${RED}if you want to use brew, you need to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc${NC}"
    fi
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then
    echo "${WHITE}Do you want to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bashrc
        echo "${GREEN}eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc successfully${NC}"
    else
        echo "${RED}if you want to use brew, you need to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc${NC}"
    fi
fi