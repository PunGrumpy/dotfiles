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
    read -r answer -p "${RED}git is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt-get install git
        echo "${GREEN}git installed${NC}"
    fi
else
    echo "${GREEN}git is installed${NC}"
fi

if test ! $(which curl)
then
    read -r answer -p "${RED}curl is not installed, do you want to install it? (y/n)${NC}"
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
    read -r answer -p "${RED}Homebrew is not installed, do you want to install it? (y/n)${NC}"
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
    read -r answer -p "${WHITE}Do you want to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bashrc
        echo "${GREEN}eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc successfully${NC}"
    else
        echo "${RED}if you want to use brew, you need to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc${NC}"
    fi
elif test "$(expr substr $(uname -s) 1 5)" = "Linux"
then
    read -r answer -p "${WHITE}Do you want to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        echo "eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> ~/.bashrc
        echo "${GREEN}eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc successfully${NC}"
    else
        echo "${RED}if you want to use brew, you need to eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) to .bashrc${NC}"
    fi
fi

# Run tools.sh
echo "${WHITE}Running tools.sh${NC}"
./tools.sh
echo "${GREEN}tools.sh finished${NC}"