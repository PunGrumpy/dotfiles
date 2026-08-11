#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/.dotfiles"
URL="https://github.com/PunGrumpy/dotfiles.git"
SHELL="${2:-fish}"

msg() { echo -e "\033[0;32m$1\033[0m"; }
err() {
  echo -e "\033[0;31mError: $1\033[0m" >&2
  exit 1
}
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

# Check dependencies
msg "📌 Checking dependencies..."
has git || err "Git not installed"
has curl || err "Curl not installed"

# Install Homebrew
if ! has brew; then
  msg "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  OS=$(uname -s)
  [ "$OS" == "Darwin" ] && eval "$(/opt/homebrew/bin/brew shellenv)" ||
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Trust Brew tap
if has brew; then
  msg "🔒 Trusting Brew tap..."
  brew trust --tap oven-sh/bun
  brew trust --tap hashicorp/tap
else
  msg "⚠️ Homebrew not installed"
fi

# Install Brewfile
if [ -f "$DOTFILES/Brewfile" ]; then
  msg "📦 Installing Brewfile..."
  brew bundle --file="$DOTFILES/Brewfile" || err "Failed to install Brewfile"
else
  msg "⚠️ Brewfile not found"
fi

# Install Agents
if has bunx; then
  msg "🧠 Installing agent skills..."
  bunx skills add https://skills.sh/p/i1xJLYPMdKUATC6X --global --yes --agent cursor
  bunx skills add https://skills.sh/p/hEe8Ruh2wWWPrZ0t --global --yes --agent cursor
else
  msg "⚠️ bunx not found, skipping agent skills install"
fi

msg "🎉 Installation completed"
msg "🐠 Install Fisher manually for Fish shell"
msg "🚀 Restart your terminal to apply changes"
