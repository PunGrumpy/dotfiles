# Run homebrew.sh and then run stow.sh

# Color
WHITE='\033[0;37m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "Hello, this is the installation script for my dotfiles"
echo "This script will install all the dependencies and link the dotfiles"

# Run homebrew.sh
echo "${WHITE}Running homebrew.sh${NC}"
./dependencies/homebrew.sh

# Run stow.sh
echo "${WHITE}Running stow.sh${NC}"
./dependencies/stow.sh

# Ask for user input
# 1. Install zsh
# 2. Install fish
echo "${WHITE}Do you want to install
1. zsh
2. fish${NC}"
read -r answer echo "${WHITE}You chose $answer${NC}"

if [ "$answer" = "1" ]; then
    echo "${WHITE}Installing zsh${NC}"
    ./zsh/install.sh
elif [ "$answer" = "2" ]; then
    echo "${WHITE}Installing fish${NC}"
    ./fish/install.sh
else
    echo "${RED}Invalid input${NC}"
fi
