#!/bin/bash

##############################################
# COLORS
##############################################
RED='\033[0;31m'
GREEN='\033[0;32m'
RESET='\033[0m'

##############################################
# VARIABLES
##############################################
OS=$(uname -s)
GITHUB_URL="https://github.com/PunGrumpy/dotfiles.git"
FISHER_URL="https://git.io/fisher"
HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
DOTFILES_PATH="$HOME/.dotfiles"

DOTFILES=false
GIT=false
CURL=false

##############################################
# FUNCTIONS
##############################################
function PRINT_MESSAGE() {
    local color=$1
    local message=$2

    echo -e "${color}${message}${RESET}"
}

function COMMAND_EXISTS() {
    command -v "$1" >/dev/null 2>&1
}

function FISH_COMMAND_EXISTS() {
    fish -c "command -v $1" >/dev/null 2>&1
}

function CLEAR() {
    clear
    sleep 0.5
}

CLEAR
##############################################
# DOTFILES PATH
##############################################
PRINT_MESSAGE "${GREEN}" "📂 Checking dotfiles path..."

if [ -d "$DOTFILES_PATH" ]; then
    DOTFILES=true
    PRINT_MESSAGE "${RED}" "⚠️ Dotfiles path already exists."
fi

##############################################
# DEPENDENCIES
##############################################
PRINT_MESSAGE "${GREEN}" "📌 Checking dependencies..."

CLEAR

PRINT_MESSAGE "${GREEN}" "🌲 Checking Git..."
if COMMAND_EXISTS "git"; then
    GIT=true
else
    echo -e "${RED}Git is not installed.${RESET}"
    exit 1
fi

CLEAR

PRINT_MESSAGE "${GREEN}" "🕸 Checking Curl..."
if COMMAND_EXISTS "curl"; then
    CURL=true
else
    echo -e "${RED}Curl is not installed.${RESET}"
    exit 1
fi

CLEAR
##############################################
# INSTALLATION
##############################################
PRINT_MESSAGE "${GREEN}" "📦 Installing..."

CLEAR

if [ "$DOTFILES" = false ]; then
    PRINT_MESSAGE "${GREEN}" "📂 Creating dotfiles path..."

    git clone --quiet "$GITHUB_URL" "$DOTFILES_PATH"

    if [ $? -eq 0 ]; then
        PRINT_MESSAGE "${GREEN}" "📂 Dotfiles installed successfully."
    else
        PRINT_MESSAGE "${RED}" "📂 Dotfiles installation failed."
        exit 1
    fi
fi

CLEAR

PRINT_MESSAGE "${GREEN}" "🍺 Getting Homebrew..."
/bin/bash -c "$(curl -fsSL $HOMEBREW_URL)"

if [ $? -eq 0 ]; then
    PRINT_MESSAGE "${GREEN}" "🍺 Homebrew installed successfully."
else
    PRINT_MESSAGE "${RED}" "🍺 Homebrew installation failed."
    exit 1
fi

CLEAR

PRINT_MESSAGE "${GREEN}" "🍺 Source Homebrew..."
if [ "$OS" = "Linux" ]; then
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
elif [ "$OS" = "Darwin" ]; then
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.zprofile
fi

CLEAR

PRINT_MESSAGE "${GREEN}" "🍺 Installing Homebrew packages..."
brew bundle --file="$DOTFILES_PATH/Brewfile"

if [ $? -eq 0 ]; then
    PRINT_MESSAGE "${GREEN}" "🍺 Homebrew packages installed successfully."
else
    PRINT_MESSAGE "${RED}" "🍺 Homebrew packages installation failed."
    exit 1
fi

CLEAR
##############################################
# SHELL
##############################################
PRINT_MESSAGE "${GREEN}" "🐚 Setting up shell..."

CLEAR

PRINT_MESSAGE "${GREEN}" "🐟 Setting up fish..."
if COMMAND_EXISTS "fish"; then
    PRINT_MESSAGE "${GREEN}" "🐟 Fish is installed."
    chsh -s "$(which fish)"
else
    PRINT_MESSAGE "${RED}" "🐟 Fish is not installed."
    exit 1
fi

CLAER

PRINT_MESSAGE "${GREEN}" "🐠 Setting up fisher..."
if FISH_COMMAND_EXISTS "fisher"; then
    PRINT_MESSAGE "${GREEN}" "🐠 Installing fisher..."
    fish -c curl -sL $FISHER_URL | source && fisher install jorgebucaran/fisher
else
    PRINT_MESSAGE "${RED}" "🐠 Fisher is not installed."
    exit 1
fi

CLEAR

PRINT_MESSAGE "${GREEN}" "🐡 Installing fisher packages..."
fish -c fisher install ilancosman/tide@v5
fish -c fisher install jethrokuan/z
fish -c fisher install PatrickF1/fzf.fish
fish -c fisher install nickeb96/puffer-fish
fish -c fisher install laughedelic/pisces

CLEAR
##############################################
# LINKS
##############################################
PRINT_MESSAGE "${GREEN}" "🔗 Creating links..."

ln -sf "$DOTFILES_PATH/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_PATH/.gitignore" "$HOME/.gitignore"
ln -sf "$DOTFILES_PATH/.czrc" "$HOME/.czrc"
ln -sf "$DOTFILES_PATH/.config" "$HOME/.config"

CLEAR
##############################################
# END
##############################################
PRINT_MESSAGE "${GREEN}" "🎉 Installation completed."