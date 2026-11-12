#!/bin/sh
# Upstash Box Init Command entry point. See README.md in this folder.
# Only /workspace survives a box rebuild, so this restores the rest on every start.
set -u

DOTFILES=$(cd "$(dirname "$0")/.." && pwd)
WORKSPACE=/workspace/home
LOGS="$WORKSPACE/.box-logs"
mkdir -p "$LOGS"
exec >>"$LOGS/start.log" 2>&1
echo "== $(date '+%F %T') start as $(id -un)"

# T3 Code names the environment after PRETTY_HOSTNAME before the hostname. The
# hostname is a random container id that cannot be changed inside the box.
echo "PRETTY_HOSTNAME=${UPSTASH_BOX_NAME:-$(hostname)}" | sudo -n tee /etc/machine-info >/dev/null

# Keep your own gh login on /workspace once it is saved there (see README.md).
if [ -f "$WORKSPACE/.config/gh/hosts.yml" ] && [ ! -L "$HOME/.config/gh" ]; then
  mkdir -p "$HOME/.config"
  rm -rf "$HOME/.config/gh"
  ln -s "$WORKSPACE/.config/gh" "$HOME/.config/gh"
fi

if ! command -v t3 >/dev/null 2>&1; then
  sudo -n npm install -g t3
fi

# Chrome cannot use its own sandbox here: the box has no AppArmor, and seccomp
# blocks user namespaces. T3 then runs Chrome with --no-sandbox, and the
# container is the isolation boundary.
T3CODE_SERVER_BROWSER_SANDBOX=0 setsid nohup t3 serve --host 0.0.0.0 --port 3773 \
  --base-dir "$WORKSPACE/.t3" >/tmp/t3.log 2>&1 </dev/null &

# The rest is slow and T3 does not need it to start, so run it in the background.
setsid nohup sh "$DOTFILES/upstash-box/setup.sh" >>"$LOGS/setup.log" 2>&1 </dev/null &
