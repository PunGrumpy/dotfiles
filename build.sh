#!/bin/bash

##############################################
# Dotfiles Setup Script
# Author: PunGrumpy
# Description: This script is used to setup dotfiles on a new machine. (macOS/Linux)
# Usage: bash build.sh
# GitHub: https://github.com/PunGrumpy/dotfiles
# License: MIT
##############################################

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

# Function to welcome user
welcome_user() {
	print_message "${GREEN}" "👋 Welcome ${USER} to dotfiles setup script."
}

# Function to clear screen
clear_screen() {
	sleep 1
	clear
	sleep 1
}

# Function to check if internet is available
check_internet() {
	ping -q -c 1 -W 1 google.com >/dev/null
}

# Function to enable non-interactive mode
enable_non_interactive() {
	read -p "Do you want to enable non-interactive mode? (y/n): " input_non_interactive
	if [ "${input_non_interactive,,}" == "y" ]; then
		export DEBIAN_FRONTEND=noninteractive
		print_message "${GREEN}" "🔒 Non-interactive mode enabled."
	fi
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

	print_message "${GREEN}" "📂 Cloning dotfiles..."
	git clone "$DOTFILES_URL" "$DOTFILES_PATH" || handle_error "Failed to clone dotfiles."
	print_message "${GREEN}" "📂 Dotfiles cloned successfully."
}

# Function to symlink dotfiles
symlink_dotfiles() {
	local dotfiles=($(find "$DOTFILES_PATH" -maxdepth 1 -name '.*' -type f))

	if [ ${#dotfiles[@]} -eq 0 ]; then
		handle_error "No dotfiles found in '$DOTFILES_PATH'."
	fi

	for file in "${dotfiles[@]}"; do
		if [ "$(basename "$file")" == ".git" ]; then
			continue
		fi
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
	if [ "$OS" == "Darwin" ]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	else
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
	print_message "${GREEN}" "🍺 Homebrew installed successfully."
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

# Function to source shell configuration
source_shell_config() {
	if [ "$SHELL_CONFIG" == "bash" ]; then
		print_message "${GREEN}" "🐚 Sourcing bash configuration..."
		if [ "$OS" == "Darwin" ]; then
			echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\"" >>"$HOME/.bash_profile"
		else
			echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >>"$HOME/.bash_profile"
		fi
		$SHELL -l || handle_error "Failed to source bash configuration."
		print_message "${GREEN}" "🐚 Bash configuration sourced successfully."
	elif [ "$SHELL_CONFIG" == "fish" ]; then
		print_message "${GREEN}" "🐠 Sourcing fish configuration..."
		$SHELL -l || handle_error "Failed to source fish configuration."
		print_message "${GREEN}" "🐠 Fish configuration sourced successfully."
	fi

	if [ "$SHELL_CONFIG" == "fish" ]; then
		if ! check_command fish; then
			print_message "${RED}" "⚠️ Fish shell is not installed."
		fi
	fi

	if [ "$SHELL_CONFIG" == "bash" ]; then
		if ! check_command bash; then
			print_message "${RED}" "⚠️ Bash shell is not installed."
		fi
	fi

	print_message "${GREEN}" "🐚 Shell configuration sourced successfully."
}

##############################################
# MAIN SCRIPT
##############################################

# Welcome user
welcome_user

# Clear screen
clear_screen

# Check internet connection
print_message "${GREEN}" "🌐 Checking internet connection..."
if ! check_internet; then
	handle_error "No internet connection."
fi

# Clear screen
clear_screen

# Enable non-interactive mode
enable_non_interactive

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

# Install Brewfile
install_brew_bundle

# Source shell configuration
source_shell_config

# Installation completed
print_message "${GREEN}" "🎉 Installation completed."
print_message "${GREEN}" "🐠 Please install Fisher manually for Fish shell configuration."
print_message "${GREEN}" "🚀 Please restart your terminal to apply changes."
