#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
URL="https://github.com/PunGrumpy/dotfiles.git"
SHELL="${2:-fish}"

msg() { echo -e "\033[0;32m$1\033[0m"; }
err() { echo -e "\033[0;31mError: $1\033[0m" >&2; exit 1; }
has() { command -v "$1" >/dev/null 2>&1; }

[[ "$SHELL" =~ ^(bash|fish|zsh)$ ]] || err "Shell must be 'bash', 'fish', or 'zsh'"

msg "👋 Welcome ${USER} to dotfiles setup"

# Clone dotfiles
if [ -d "$DOTFILES" ]; then
	read -p "Remove existing dotfiles? (y/n): " ans
	[[ "${ans,,}" == "y" ]] && rm -rf "$DOTFILES" || exit 0
fi

msg "📂 Cloning dotfiles..."
git clone "$URL" "$DOTFILES" || err "Failed to clone dotfiles"

# Symlink dotfiles
msg "🔗 Creating symlinks..."
find "$DOTFILES" -maxdepth 1 -name '.*' -type f ! -name '.git' -exec ln -sf {} "$HOME/" \;
ln -sf "$DOTFILES/.config" "$HOME/.config"
ln -sf "$DOTFILES/.scripts" "$HOME/.scripts"

# Setup Cursor/OpenCode symlinks
if [ -d "$DOTFILES/.agents" ]; then
	msg "🔗 Setting up Cursor symlinks..."
	AGENTS="$DOTFILES/.agents"
	OPencode_DIR="$DOTFILES/.config/opencode"
	CURSOR_DIR="$HOME/.cursor"
	
	mkdir -p "$AGENTS"/{skills,commands} "$CURSOR_DIR"
	
	# Backup and symlink ~/.agents
	[ -e "$HOME/.agents" ] && [ ! -L "$HOME/.agents" ] && \
		mv "$HOME/.agents" "$HOME/.agents.backup-$(date +%Y%m%d-%H%M%S)"
	ln -sf "$AGENTS" "$HOME/.agents"
	
	# Backup Cursor config if exists and not symlink
	[ -e "$CURSOR_DIR/skills" ] && [ ! -L "$CURSOR_DIR/skills" ] && {
		BACKUP="$CURSOR_DIR.backup-$(date +%Y%m%d-%H%M%S)"
		mkdir -p "$BACKUP"
		[ -d "$CURSOR_DIR/skills" ] && cp -a "$CURSOR_DIR/skills" "$BACKUP/" 2>/dev/null || true
		[ -d "$CURSOR_DIR/commands" ] && cp -a "$CURSOR_DIR/commands" "$BACKUP/" 2>/dev/null || true
	}
	
	# Symlink to .config/opencode/ and ~/.cursor/
	for dir in "$OPencode_DIR" "$CURSOR_DIR"; do
		rm -rf "$dir"/{skills,commands}
		ln -sf "$AGENTS/skills" "$dir/skills"
		ln -sf "$AGENTS/commands" "$dir/commands"
	done
fi

# Check dependencies
msg "📌 Checking dependencies..."
has git || err "Git not installed"
has curl || err "Curl not installed"

# Install Homebrew
if ! has brew; then
	msg "🍺 Installing Homebrew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	OS=$(uname -s)
	[ "$OS" == "Darwin" ] && eval "$(/opt/homebrew/bin/brew shellenv)" || \
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Install Brewfile
if [ -f "$DOTFILES/Brewfile" ]; then
	msg "📦 Installing Brewfile..."
	brew bundle --file="$DOTFILES/Brewfile" || err "Failed to install Brewfile"
else
	msg "⚠️ Brewfile not found"
fi

msg "🎉 Installation completed"
msg "🐠 Install Fisher manually for Fish shell"
msg "🚀 Restart your terminal to apply changes"
