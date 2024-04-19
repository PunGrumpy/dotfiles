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
DOTFILES_PATH="$HOME/.dotfiles"
DOTFILES_URL="https://github.com/PunGrumpy/dotfiles.git"
HOMEBREW_URL="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
SHELL_CONFIG="fish" # Default shell configuration

##############################################
# FUNCTIONS
##############################################

# Function to print messages in color
print_message() {
	local color=$1
	local message=$2
	echo -e "${color}${message}${RESET}"
}

# Function to clear screen
clear_screen() {
	sleep 1
	clear
	sleep 1
}

# Function to check if a command is available
check_command() {
    command -v "$1" >/dev/null 2>&1
}

# Function to handle errors
handle_error() {
	local message="$1"
	print_message "${RED}" "Error: $message"
	exit 1
}

# Function to validate shell configuration input
validate_shell_config() {
	local shell_config="$1"
	if [[ "$shell_config" != "bash" && "$shell_config" != "fish" ]]; then
		handle_error "Invalid shell configuration. Please enter 'bash' or 'fish'."
	fi
}

# Function to install dotfiles
install_dotfiles() {
	if [ -z "$DOTFILES_URL" ]; then
		handle_error "Dotfiles URL is not provided."
	fi

	if [ -d "$DOTFILES_PATH" ]; then
		print_message "${RED}" "⚠️ Dotfiles path already exists."
		read -p "Do you want to remove the existing dotfiles path? (y/n): " input_remove

		if [ "${input_remove,,}" == "y" ]; then
			print_message "${GREEN}" "📂 Removing dotfiles path..."
			rm -rf "$DOTFILES_PATH" || handle_error "Failed to remove dotfiles."
			print_message "${GREEN}" "📂 Dotfiles path removed successfully."
		else
			print_message "${RED}" "⚠️ Dotfiles path not removed."
		fi
	fi

	if [ ! -d "$DOTFILES_PATH" ]; then
		print_message "${GREEN}" "📂 Cloning dotfiles..."
		git clone "$DOTFILES_URL" "$DOTFILES_PATH" || handle_error "Failed to clone dotfiles."
		print_message "${GREEN}" "📂 Dotfiles cloned successfully."
	fi
}

# Function to symlink dotfiles
symlink_dotfiles() {
	local dotfiles=("$(find "$DOTFILES_PATH" -maxdepth 1 -name '.*' -type f)")

	if [ ${#dotfiles[@]} -eq 0 ]; then
		handle_error "No dotfiles found in '$DOTFILES_PATH'."
	fi

	for file in "${dotfiles[@]}"; do
		local filename=$(basename "$file")
		ln -sf "$file" "$HOME/$filename"
	done

	ln -sf "$DOTFILES_PATH/.config" "$HOME"
	ln -sf "$DOTFILES_PATH/.scripts" "$HOME"
	print_message "${GREEN}" "🔗 Creating symlinks... Done."
}

# Function to install Homebrew
install_homebrew() {
	print_message "${GREEN}" "🍺 Getting Homebrew..."
	/bin/bash -c "$(curl -fsSL $HOMEBREW_URL)" || handle_error "Failed to install Homebrew."
	print_message "${GREEN}" "🍺 Homebrew installed successfully."
}

# Function to source shell configuration
source_shell_config() {
	if [ "$SHELL_CONFIG" == "fish" ]; then
		print_message "${GREEN}" "🐟 Setting up Fish..."
		check_command fish || handle_error "Fish shell is not installed."
		local brew_shellenv="/usr/local/bin/brew shellenv"
		if [ "$OS" != "Darwin" ]; then
			brew_shellenv="/home/linuxbrew/.linuxbrew/bin/brew shellenv"
		fi
		echo "eval ($brew_shellenv)" >>~/.config/fish/config.fish
		print_message "${GREEN}" "🐟 Fisher is installed."
	else
		print_message "${GREEN}" "📝 Setting up Bash..."
		local shellenv_command="\$(/usr/local/bin/brew shellenv)"
		if [ "$OS" != "Darwin" ]; then
			shellenv_command="\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
		fi
		echo "eval \"$shellenv_command\"" >>~/.bash_profile
		print_message "${GREEN}" "📝 Bash setup completed."
	fi
}

# Function to install brew bundle
install_brew_bundle() {
	print_message "${GREEN}" "📦 Installing Brewfile..."
	if [ -f "$DOTFILES_PATH/Brewfile" ]; then
		brew bundle --file="$DOTFILES_PATH/Brewfile" || handle_error "Failed to install Brewfile."
		print_message "${GREEN}" "📦 Brewfile installed successfully."
	else
		print_message "${RED}" "⚠️ Brewfile not found."
	fi
}

##############################################
# MAIN SCRIPT
##############################################

# Clear screen
clear_screen

# Ask for dotfiles URL
read -p "Enter the URL for dotfiles repository (default: $DOTFILES_URL): " input_url
DOTFILES_URL=${input_url:-$DOTFILES_URL}

# Ask for shell configuration
read -p "Enter the shell configuration (bash/fish): " input_shell
SHELL_CONFIG=${input_shell:-$SHELL_CONFIG}

# Validate shell configuration input
validate_shell_config "$SHELL_CONFIG"

# Install dotfiles
install_dotfiles

# Symlink dotfiles
symlink_dotfiles

# Check dependencies
print_message "${GREEN}" "📌 Checking dependencies..."
check_command git || handle_error "Git is not installed."
check_command curl || handle_error "Curl is not installed."

# Install Homebrew
install_homebrew

# Source shell configuration
source_shell_config

# Install Brewfile
install_brew_bundle

# Installation completed
print_message "${GREEN}" "🎉 Installation completed."
print_message "${GREEN}" "🐠 Please install Fisher manually for Fish shell configuration."
print_message "${GREEN}" "🚀 Please restart your terminal to apply changes."
