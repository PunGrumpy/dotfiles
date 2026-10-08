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

# Set login shell
if shell_path="$(command -v "$SHELL")"; then
  msg "🐚 Setting ${SHELL} as login shell..."
  grep -qxF "$shell_path" /etc/shells || echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
  chsh -s "$shell_path" || msg "⚠️ chsh failed, run: chsh -s $shell_path"
else
  msg "⚠️ ${SHELL} not found, skipping login shell"
fi

# Configure macOS Dock
if [ "$(uname -s)" == "Darwin" ] && [ -x "$DOTFILES/.scripts/dock" ]; then
  read -p "Reconfigure the macOS Dock? (y/n): " dock_ans
  if [[ "${dock_ans,,}" == "y" ]]; then
    msg "🚢 Configuring Dock..."
    "$DOTFILES/.scripts/dock"
  fi
fi

# Install Agents
if has bunx; then
  msg "🧠 Installing agent skills..."
  skill() { bunx skills add "$@" --global --yes --agent cursor; }
  skill mattpocock/skills --skill grill-me
  skill vercel-labs/agent-skills --skill writing-guidelines
  skill shadcn/improve --skill improve
  skill vercel/turborepo --skill turborepo
  skill millionco/react-doctor --skill react-doctor improve-react improve-threejs performance deslop
  skill rauchg/skills --skill ui-recording-timeline
  skill emilkowalski/skills --skill emil-design-eng review-animations
  skill gustavo-fior/craft --skill craft-design-engineering
  skill git@github.com:PunGrumpy/agents.git --skill cli-builder devops-engineer style-transfer system-design testing-patterns
else
  msg "⚠️ bunx not found, skipping agent skills install"
fi

msg "🎉 Installation completed"
msg "🐠 Install Fisher manually for Fish shell"
msg "🚀 Restart your terminal to apply changes"
