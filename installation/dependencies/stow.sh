# Stow installation script

# Color
WHITE='\033[0;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Ask to install Stow if not installed yet and install it
if test ! $(which stow)
then
    read -r answer -p "${RED}Stow is not installed, do you want to install it? (y/n)${NC}"
    if [ "$answer" = "y" ]; then
        sudo apt-get install stow
        echo "${GREEN}Stow installed${NC}"
    fi
else
    echo "${GREEN}Stow is installed${NC}"
fi