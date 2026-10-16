#!/usr/bin/env bash
# A separate APFS volume for code: no Spotlight, no fseventsd log.
#
#   dev-volume.sh create   make the encrypted volume (asks for a volume password and sudo)
#   dev-volume.sh link     move projects, T3 worktrees and package caches onto it
set -euo pipefail

VOL=Dev
MNT=/Volumes/$VOL
CACHES=$MNT/caches

msg() { echo -e "\033[0;32m$1\033[0m"; }
err() {
  echo -e "\033[0;31mError: $1\033[0m" >&2
  exit 1
}
has() { command -v "$1" >/dev/null 2>&1; }

create() {
  [ -d "$MNT" ] && err "$MNT already exists"
  local container
  container=$(diskutil info / | awk '/APFS Container:/ {print $3}')

  msg "💽 Creating encrypted APFS volume '$VOL' in $container (save the password in 1Password)"
  diskutil apfs addVolume "$container" APFS "$VOL" -passprompt
  sudo chown "$USER":staff "$MNT"

  msg "🔕 Disabling Spotlight and the fseventsd log"
  sudo mdutil -i off -d "$MNT"
  touch "$MNT/.metadata_never_index"
  sudo rm -rf "$MNT/.fseventsd"
  sudo mkdir "$MNT/.fseventsd"
  sudo touch "$MNT/.fseventsd/no_log"

  msg "🔁 Remounting"
  local dev
  dev=$(diskutil info "$MNT" | awk '/Device Identifier:/ {print $3}')
  diskutil unmount "$MNT"
  diskutil apfs unlockVolume "$dev"
  mdutil -s "$MNT"
  msg "✅ Done. Disk Utility > $VOL > Unmount, Mount, tick 'Remember this password in my keychain'."
}

# Move $1 to $2 (skipping build output) and leave a symlink behind. Keeps $1.bak.
move_and_link() {
  local src=$1 dst=$2
  if [ -L "$src" ]; then
    msg "  $src already links to $(readlink "$src")"
    return
  fi
  mkdir -p "$dst"
  if [ -d "$src" ]; then
    # Build caches that mark themselves (Cargo's target/) are skipped too.
    local skip
    skip=$(mktemp)
    (cd "$src" && find . -name node_modules -prune -o -name CACHEDIR.TAG -print |
      sed -e 's|^\.||' -e 's|/CACHEDIR.TAG$|/|') >"$skip"
    rsync -aH --delete --delete-excluded --exclude-from="$skip" \
      --exclude=node_modules/ --exclude=.next/ --exclude=.turbo/ \
      "$src/" "$dst/"
    rm -f "$skip"
    mv "$src" "$src.bak"
  fi
  mkdir -p "$(dirname "$src")"
  ln -s "$dst" "$src"
  msg "  $src -> $dst"
}

# Move an existing cache's contents to $2 so nothing has to be downloaded again.
move_cache() {
  local src=$1 dst=$2
  mkdir -p "$dst"
  [ -d "$src" ] && [ ! -L "$src" ] && [ "$src" != "$dst" ] || return 0
  chmod -R u+w "$src" # Go makes its module cache read-only
  rsync -aH "$src/" "$dst/"
  rm -rf "$src"
  msg "  $src -> $dst"
}

link() {
  mount | grep -q " on $MNT " || err "$MNT is not mounted"
  mkdir -p "$CACHES"

  msg "📂 Projects and T3 worktrees"
  move_and_link "$HOME/Developments" "$MNT/Developments"
  move_and_link "$HOME/.t3/worktrees" "$MNT/t3-worktrees"

  msg "📦 Package caches"
  move_cache "$HOME/.bun/install/cache" "$CACHES/bun"
  printf '[install.cache]\ndir = "%s"\n' "$CACHES/bun" >"$HOME/.bunfig.toml"
  if has pnpm; then
    move_cache "$HOME/Library/pnpm/store" "$CACHES/pnpm-store"
    pnpm config set store-dir "$CACHES/pnpm-store" --global
  fi
  if has npm; then
    move_cache "$HOME/.npm" "$CACHES/npm"
    npm config set cache "$CACHES/npm"
  fi
  if has go; then
    move_cache "$(go env GOMODCACHE)" "$CACHES/go-mod"
    move_cache "$(go env GOCACHE)" "$CACHES/go-build"
    go env -w GOMODCACHE="$CACHES/go-mod" GOCACHE="$CACHES/go-build"
  fi
  if [ -d "$HOME/.cargo" ]; then
    move_cache "$HOME/.cargo/registry" "$CACHES/cargo-registry"
    [ -e "$HOME/.cargo/registry" ] || ln -s "$CACHES/cargo-registry" "$HOME/.cargo/registry"
  fi

  msg "✅ Done. Old copies are kept as *.bak; reinstall node_modules per project."
}

case "${1:-}" in
create) create ;;
link) link ;;
*) err "usage: $(basename "$0") create|link" ;;
esac
