# Run homebrew.sh and then run stow.sh

# sleep and clear
sleep_clear() {
    sleep 2
    clear
}

# check cowsay, lolcat, fortune, figlet and toilet are installed
if [ -x "$(command -v cowsay)" ] && [ -x "$(command -v lolcat)" ] && [ -x "$(command -v fortune)" ] && [ -x "$(command -v figlet)" ] && [ -x "$(command -v toilet)" ]; then
    sudo apt install cowsay lolcat fortune figlet toilet -y
    sleep_clear

    echo "Next, we will install dotfiles and dependencies" | toilet -f term -F border | lolcat
    sleep_clear
fi

# Welcome message
echo "Welcome to my dotfiles" | figlet | lolcat -a -d 5
echo "This script will install all the dependencies and link the dotfiles" | toilet -f term -F border | lolcat
sleep_clear

# Install dependencies - homebrew
echo "Running homebrew.sh" | toilet -f term -F border | lolcat
./dependencies/homebrew.sh
sleep_clear

# Instral dependencies - stow
echo "Running stow.sh" | toilet -f term -F border | lolcat
./dependencies/stow.sh
sleep_clear

# Install zsh or fish
echo "Do you want to install zsh or fish?" | toilet -f term -F border | lolcat
echo "1. zsh"
echo "2. fish"
read -r -p "Do you want to install zsh or fish? [1/2]: " answer | toilet -f term -F border | lolcat
if [ "$answer" = "1" ]; then
    echo "Installing zsh" | toilet -f term -F border | lolcat
    ./zsh/install.sh
elif [ "$answer" = "2" ]; then
    echo "Installing fish" | toilet -f term -F border | lolcat
    ./fish/install.sh
else
    echo "Invalid input" | toilet -f term -F border | lolcat
fi
sleep_clear

# Done message
echo "Done!" | figlet | lolcat -a -d 5