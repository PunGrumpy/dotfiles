# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Check fisher is installed, if not ask to install it
if [ -d ~/.config/fish/functions/fisher.fish ]; then
    echo "${GREEN}fisher is installed${NC}"
else
    echo "${RED}fisher is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    fi
fi

# Check tide-fish is installed, if not ask to install it
if [ -d ~/.config/fish/functions/fisher.fish ]; then
    echo "${GREEN}tide-fish is installed${NC}"
else
    echo "${RED}tide-fish is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        fisher add IlanCosman/tide
    fi
fi

# Check z for fish is installed, if not ask to install it
if [ -d ~/.config/fish/functions/fisher.fish ]; then
    echo "${GREEN}z for fish is installed${NC}"
else
    echo "${RED}z for fish is not installed${NC}"
    echo "${RED}Do you want to install it? (y/n)${NC}"
    read -r answer
    if [ "$answer" = "y" ]; then
        fisher add jethrokuan/z
    fi
fi