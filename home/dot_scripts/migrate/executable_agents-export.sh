#!/usr/bin/env bash
# Back up T3 Code, every agent home it drives and the code on the Dev volume into
# two encrypted archives, to restore on a new machine (another Mac, or WSL with the
# same home path). Quit T3 Code, Codex and every Claude Code session first.
#
#   agents-export.sh [OUT_DIR]   # default ~/agents-bak-DATE; copy it to an external drive
#
# On the new machine (needs openssl and zstd; asks for the passphrase set here):
#   dec() { openssl enc -d -aes-256-cbc -pbkdf2 -iter 600000 -in "$1" | zstd -dc | tar -x -C "$2"; }
#   dec home.tar.zst.enc ~
#   dec dev.tar.zst.enc /Volumes/Dev
#   # different home path? then:
#   ~/.scripts/migrate/agents-rewrite-paths.sh /Users/OLD /Users/NEW
# Logins (keychain entries, T3 device pairing) don't travel; sign in again.
set -euo pipefail

OUT=${1:-$HOME/agents-bak-$(date +%Y%m%d-%H%M)}
DEV=/Volumes/Dev
ENC=(-aes-256-cbc -pbkdf2 -iter 600000)

msg() { echo -e "\033[0;32m$1\033[0m"; }
err() {
  echo -e "\033[0;31mError: $1\033[0m" >&2
  exit 1
}

pgrep -fiq 't3[ -]?code' && err "T3 Code is still running; quit it first"
pgrep -xq codex && err "Codex is still running; quit it first"
command -v zstd >/dev/null || err "zstd is missing (brew install zstd)"
[ -e "$OUT" ] && err "$OUT already exists"

read -rsp "Passphrase for the backup: " pass && echo
read -rsp "Again: " again && echo
[ -n "$pass" ] || err "empty passphrase"
[ "$pass" = "$again" ] || err "passphrases differ"
mkdir -p "$OUT"

# pack ARCHIVE DIR [--exclude=...] ITEMS...
pack() {
  local out=$OUT/$1 dir=$2
  shift 2
  msg "📦 $dir -> $out"
  COPYFILE_DISABLE=1 tar -cf - --no-mac-metadata --exclude='.DS_Store' --exclude='*.sock' -C "$dir" "$@" |
    zstd -T0 -qc |
    openssl enc "${ENC[@]}" -salt -pass fd:3 -out "$out" 3<<<"$pass"
  openssl enc -d "${ENC[@]}" -pass fd:3 -in "$out" 3<<<"$pass" | zstd -tq
}

# Every agent home T3 can drive (one per provider account), plus the links into the Dev volume.
cd "$HOME"
home=(.t3/userdata)
for p in .t3/worktrees Developments .claude .claude-* .claude.json .codex .codex-* .gemini .grok; do
  if [ -e "$p" ] || [ -L "$p" ]; then home+=("$p"); fi
done
pack home.tar.zst.enc "$HOME" \
  --exclude='.t3/userdata/logs' --exclude='*.bak-*' --exclude='*-bak-*' \
  --exclude='*/shell-snapshots' --exclude='*/telemetry' \
  --exclude='.codex*/packages' --exclude='.codex*/log' --exclude='.codex*/logs_*.sqlite*' --exclude='.codex*/tmp' \
  "${home[@]}"

# Dependencies and build output are per-platform; reinstall them on the new machine.
if [ -d "$DEV/Developments" ]; then
  cd "$DEV"
  dev=(Developments)
  [ -d t3-worktrees ] && dev+=(t3-worktrees)
  # Build caches that mark themselves (Cargo's target/) are skipped too.
  skip=$(mktemp)
  find "${dev[@]}" -name node_modules -prune -o -name CACHEDIR.TAG -print | sed 's|/CACHEDIR.TAG$||' >"$skip"
  pack dev.tar.zst.enc "$DEV" -X "$skip" \
    --exclude='node_modules' --exclude='.venv' --exclude='.next' --exclude='.turbo' \
    "${dev[@]}"
  rm -f "$skip"
fi

(cd "$OUT" && shasum -a 256 ./*.enc >SHA256SUMS)
msg "✅ $(du -sh "$OUT" | cut -f1)  $OUT  Old home: $HOME"
