#!/usr/bin/env bash
# Pack T3 Code and Claude Code state into one archive to carry to a new machine.
# Quit T3 Code and every Claude Code session first.
#
#   agents-export.sh [OUT.tgz]
#
# On the new machine:
#   tar -xzf agents-*.tgz -C ~
#   # different home path? then:
#   ~/.scripts/migrate/agents-rewrite-paths.sh /Users/OLD /Users/NEW
# Logins (Claude Code keychain entry, T3 device pairing) don't travel; sign in again.
set -euo pipefail

OUT=${1:-$HOME/agents-$(date +%Y%m%d).tgz}
CLAUDE=${CLAUDE_CONFIG_DIR:-$HOME/.claude}

msg() { echo -e "\033[0;32m$1\033[0m"; }
err() {
  echo -e "\033[0;31mError: $1\033[0m" >&2
  exit 1
}

pgrep -fiq 't3[ -]?code' && err "T3 Code is still running; quit it first"

items=(.t3/userdata "${CLAUDE#"$HOME"/}")
[ -f "$HOME/.claude.json" ] && items+=(.claude.json)

msg "📦 Packing ${items[*]} -> $OUT"
tar -czf "$OUT" -C "$HOME" \
  --exclude='.t3/userdata/logs' --exclude='*.bak-*' \
  --exclude="${CLAUDE#"$HOME"/}/shell-snapshots" --exclude="${CLAUDE#"$HOME"/}/telemetry" \
  "${items[@]}"
msg "✅ $(du -h "$OUT" | cut -f1)  Old home: $HOME"
