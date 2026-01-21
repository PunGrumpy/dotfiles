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

# Function to setup Cursor and OpenCode symlinks
setup_cursor_symlinks() {
	local cursor_dir="$HOME/.cursor"
	local agents_source="$DOTFILES_PATH/.agents"
	local agents_home="$HOME/.agents"
	local opencode_dir="$DOTFILES_PATH/.config/opencode"

	# Check if .dotfiles/.agents exists (source of truth)
	if [ ! -d "$agents_source" ]; then
		print_message "${RED}" "⚠️ .dotfiles/.agents directory not found. Skipping symlinks."
		return
	fi

	# Ensure .agents/skills and .agents/commands exist in source
	if [ ! -d "$agents_source/skills" ]; then
		mkdir -p "$agents_source/skills"
		print_message "${GREEN}" "📁 Created .dotfiles/.agents/skills directory"
	fi

	if [ ! -d "$agents_source/commands" ]; then
		mkdir -p "$agents_source/commands"
		print_message "${GREEN}" "📁 Created .dotfiles/.agents/commands directory"
	fi

	# 1. Create symlink ~/.agents -> .dotfiles/.agents
	if [ -e "$agents_home" ] && [ ! -L "$agents_home" ]; then
		local backup_dir="$agents_home.backup-$(date +%Y%m%d-%H%M%S)"
		print_message "${GREEN}" "📦 Backing up existing ~/.agents to $backup_dir..."
		mv "$agents_home" "$backup_dir"
	fi
	[ -L "$agents_home" ] && rm "$agents_home" || true
	ln -sf "$agents_source" "$agents_home"
	print_message "${GREEN}" "🔗 Created symlink: ~/.agents -> .dotfiles/.agents"

	# 2. Create symlinks in .config/opencode/
	[ -e "$opencode_dir/skills" ] && rm -rf "$opencode_dir/skills" || true
	[ -e "$opencode_dir/commands" ] && rm -rf "$opencode_dir/commands" || true
	ln -sf "$agents_source/skills" "$opencode_dir/skills"
	ln -sf "$agents_source/commands" "$opencode_dir/commands"
	print_message "${GREEN}" "🔗 Created symlinks in .config/opencode/"

	# 3. Create .cursor directory if it doesn't exist
	if [ ! -d "$cursor_dir" ]; then
		mkdir -p "$cursor_dir"
	fi

	# Backup existing skills/commands if they exist and are not symlinks
	if [ -e "$cursor_dir/skills" ] && [ ! -L "$cursor_dir/skills" ]; then
		local backup_dir="$cursor_dir.backup-$(date +%Y%m%d-%H%M%S)"
		print_message "${GREEN}" "📦 Backing up existing Cursor config to $backup_dir..."
		mkdir -p "$backup_dir"
		[ -d "$cursor_dir/skills" ] && cp -a "$cursor_dir/skills" "$backup_dir/" 2>/dev/null || true
		[ -d "$cursor_dir/commands" ] && cp -a "$cursor_dir/commands" "$backup_dir/" 2>/dev/null || true
	fi

	# 4. Create symlinks in ~/.cursor/
	rm -rf "$cursor_dir/skills"
	ln -sf "$agents_source/skills" "$cursor_dir/skills"

	rm -rf "$cursor_dir/commands"
	ln -sf "$agents_source/commands" "$cursor_dir/commands"
	print_message "${GREEN}" "🔗 Created symlinks in ~/.cursor/"

	print_message "${GREEN}" "🔗 Cursor symlinks created successfully."
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

##############################################
# MAIN SCRIPT
##############################################

# Clear screen
clear_screen

# Welcome user
welcome_user

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

# Setup Cursor symlinks
setup_cursor_symlinks

# Check dependencies
print_message "${GREEN}" "📌 Checking dependencies..."
check_command git || handle_error "Git is not installed."
check_command curl || handle_error "Curl is not installed."

# Install Homebrew
install_homebrew

# Install Brewfile
install_brew_bundle

# Installation completed
print_message "${GREEN}" "🎉 Installation completed."
print_message "${GREEN}" "🐠 Please install Fisher manually for Fish shell configuration."
print_message "${GREEN}" "🚀 Please restart your terminal to apply changes."
