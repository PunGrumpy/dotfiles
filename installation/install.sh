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
./homebrew.sh

# Run stow.sh
echo "${WHITE}Running stow.sh${NC}"
./stow.sh

# Ascii art "Thanks for using my dotfiles"
echo "${GREEN}Thanks for using my dotfiles${NC}"
echo "  _   _      _ _        __        __         _     _ _ "
echo " | | | | ___| | | ___   \ \      / /__  _ __| | __| | |"
echo " | |_| |/ _ \ | |/ _ \   \ \ /\ / / _ \| '__| |/ _\` | |"
echo " |  _  |  __/ | | (_) |   \ V  V / (_) | |  | | (_| |_|"
echo " |_| |_|\___|_|_|\___( )   \_/\_/ \___/|_|  |_|\__,_(_)"
echo "                     |/                                 "

# End of script
