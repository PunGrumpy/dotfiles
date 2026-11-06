# macOS

## Set up a new Mac

Run these steps by hand after `chezmoi apply`:

1. Download [Rex](https://www.superlogical.com/rex). Rex has no Homebrew cask.
2. Run `~/.scripts/rex` to set the Rex preferences. The script restarts Rex.
3. Run `~/.scripts/dock` to rebuild the Dock.

## Move to a new Mac

Code lives on its own APFS volume, `/Volumes/Dev`, with no Spotlight index and no fseventsd log. `~/Developments` links to the volume.

```bash
# old Mac: quit T3 Code, Codex and Claude Code, then back up into ~/agents-bak-DATE (asks for a passphrase)
~/.scripts/migrate/agents-export.sh

# new Mac
~/.scripts/migrate/dev-volume.sh create   # then tick "Remember password" in Disk Utility
dec() { openssl enc -d -aes-256-cbc -pbkdf2 -iter 600000 -in "$1" | zstd -dc | tar -x -C "$2"; }
dec agents-bak-DATE/dev.tar.zst.enc /Volumes/Dev
~/.scripts/migrate/dev-volume.sh link     # projects, T3 worktrees, package caches
dec agents-bak-DATE/home.tar.zst.enc ~
~/.scripts/migrate/agents-rewrite-paths.sh /Users/OLD /Users/NEW   # only if the home path changed
```
