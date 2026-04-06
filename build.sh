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
  bunx skills add vercel-labs/agent-skills --global --yes --agent cursor --skill vercel-react-best-practices web-design-guidelines vercel-composition-patterns
  bunx skills add vercel-labs/next-skills --global --yes --agent cursor --skill next-cache-components
  bunx skills add vercel/turborepo --global --yes --agent cursor --skill turborepo
  bunx skills add coreyhaines31/marketingskills --global --yes --agent cursor --skill seo-audit
  bunx skills add mattpocock/skills --global --yes --agent cursor --skill grill-me write-a-prd qa
  bunx skills add shadcn/ui --global --yes --agent cursor --skill shadcn
  bunx skills add joyco-studio/skills --global --yes --agent cursor
  bunx skills add emilkowalski/skill --global --yes --agent cursor
  bunx skills add git@github.com:PunGrumpy/agents.git --global --yes --agent cursor
else
  msg "⚠️ bunx not found, skipping agent skills install"
fi

msg "🎉 Installation completed"
msg "🐠 Install Fisher manually for Fish shell"
msg "🚀 Restart your terminal to apply changes"
