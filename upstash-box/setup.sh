#!/bin/sh
# Background part of start.sh: browser libraries, then the dotfiles.
set -u
DOTFILES=$(cd "$(dirname "$0")/.." && pwd)
echo "== $(date '+%F %T') setup"

# What `t3 browser setup` installs, minus its AppArmor step, which a container cannot do.
BROWSER_PKGS="libnss3 libglib2.0-0 libatk1.0-0 libatk-bridge2.0-0 libatspi2.0-0 libdbus-1-3 libx11-6 libxcb1 libxcomposite1 libxdamage1 libxext6 libxfixes3 libxrandr2 libxkbcommon0 libgbm1 libasound2 libexpat1 fontconfig fonts-liberation"
# shellcheck disable=SC2086 # word splitting is intended
if ! dpkg -s $BROWSER_PKGS >/dev/null 2>&1; then
  sudo -n apt-get update -qq &&
    sudo -n env DEBIAN_FRONTEND=noninteractive apt-get install -y -qq --no-install-recommends $BROWSER_PKGS
fi

# chezmoi keeps its state in $HOME, which a rebuild wipes, so a rebuilt box
# installs everything again and a resumed box skips what already ran.
if [ ! -x "$HOME/.local/bin/chezmoi" ]; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
fi
NONINTERACTIVE=1 "$HOME/.local/bin/chezmoi" init --apply --force --source "$DOTFILES"
echo "== $(date '+%F %T') setup exit=$?"
