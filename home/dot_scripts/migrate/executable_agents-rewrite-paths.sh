#!/usr/bin/env bash
# After moving T3 Code and Claude Code to a machine where the home path differs,
# rewrite the old path prefix so threads, projects and Claude sessions line up again.
# Quit T3 Code and every Claude Code session first. Backs everything up before writing.
#
#   agents-rewrite-paths.sh [--dry-run] OLD_PREFIX NEW_PREFIX
#   agents-rewrite-paths.sh /Users/noppakorn /Users/pun
set -euo pipefail

DRY=0
if [ "${1:-}" = "--dry-run" ]; then
  DRY=1
  shift
fi
OLD=${1:?old prefix}
NEW=${2:?new prefix}
OLD=${OLD%/}
NEW=${NEW%/}
T3=$HOME/.t3/userdata
CLAUDE=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
STAMP=$(date +%Y%m%d-%H%M%S)

msg() { echo -e "\033[0;32m$1\033[0m"; }
err() {
  echo -e "\033[0;31mError: $1\033[0m" >&2
  exit 1
}
q() { printf "'%s'" "${1//\'/\'\'}"; }
# Claude Code names a project folder after its path with every non-alphanumeric as '-'.
encode() { printf '%s' "$1" | sed 's/[^A-Za-z0-9]/-/g'; }

if [ $DRY -eq 0 ] && pgrep -fiq 't3[ -]?code'; then
  err "T3 Code is still running; quit it first"
fi

msg "🗄️  T3 Code ($T3)"
for db in "$T3"/statev2.sqlite "$T3"/state.sqlite; do
  [ -f "$db" ] || continue
  echo "### $(basename "$db")"
  target=$db
  if [ $DRY -eq 1 ]; then
    target=$(mktemp -d)/$(basename "$db")
    sqlite3 "$db" ".backup $(q "$target")"
  else
    sqlite3 "$db" ".backup $(q "$db.bak-$STAMP")"
    echo "  backup: $db.bak-$STAMP"
  fi

  sql="BEGIN;"
  for t in $(sqlite3 "$target" "select name from sqlite_master where type='table' and name not like 'sqlite_%'"); do
    for c in $(sqlite3 "$target" "select name from pragma_table_info('$t') where type like '%TEXT%' or type=''"); do
      n=$(sqlite3 "$target" "select count(*) from \"$t\" where instr(\"$c\", $(q "$OLD/")) > 0 or instr(\"$c\", $(q "\"$OLD\"")) > 0 or \"$c\" = $(q "$OLD")")
      [ "$n" -gt 0 ] || continue
      echo "  $t.$c: $n rows"
      sql+="UPDATE \"$t\" SET \"$c\" = replace(\"$c\", $(q "$OLD/"), $(q "$NEW/")) WHERE instr(\"$c\", $(q "$OLD/")) > 0;"
      sql+="UPDATE \"$t\" SET \"$c\" = replace(\"$c\", $(q "\"$OLD\""), $(q "\"$NEW\"")) WHERE instr(\"$c\", $(q "\"$OLD\"")) > 0;"
      sql+="UPDATE \"$t\" SET \"$c\" = $(q "$NEW") WHERE \"$c\" = $(q "$OLD");"
    done
  done
  sql+="COMMIT;"
  sqlite3 "$target" "$sql"
  echo "  integrity: $(sqlite3 "$target" 'pragma integrity_check')"
  [ $DRY -eq 1 ] && rm -rf "$(dirname "$target")"
done

msg "🤖 Claude Code ($CLAUDE)"
old_enc=$(encode "$OLD")
new_enc=$(encode "$NEW")
renames=0
if [ $DRY -eq 0 ] && [ -d "$CLAUDE/projects" ]; then
  tar -czf "$CLAUDE.projects-bak-$STAMP.tgz" -C "$CLAUDE" projects
  echo "  backup: $CLAUDE.projects-bak-$STAMP.tgz"
fi
if [ -d "$CLAUDE/projects" ]; then
  for dir in "$CLAUDE/projects/$old_enc" "$CLAUDE/projects/$old_enc"-*; do
    [ -d "$dir" ] || continue
    name=$(basename "$dir")
    to="$CLAUDE/projects/$new_enc${name#"$old_enc"}"
    renames=$((renames + 1))
    if [ -e "$to" ]; then
      echo "  skip (exists): $(basename "$to")"
    elif [ $DRY -eq 0 ]; then
      mv "$dir" "$to"
    fi
  done
fi
echo "  session folders to rename: $renames"

if [ $DRY -eq 0 ]; then
  # Absolute paths inside transcripts (cwd) and the per-project settings in .claude.json.
  [ -d "$CLAUDE/projects" ] && find "$CLAUDE/projects" -name '*.jsonl' \
    -exec perl -pi -e "s#\Q$OLD/\E#$NEW/#g; s#\"\Q$OLD\E\"#\"$NEW\"#g" {} +
  for json in "$HOME/.claude.json" "$CLAUDE/.claude.json"; do
    [ -f "$json" ] || continue
    cp "$json" "$json.bak-$STAMP"
    perl -pi -e "s#\Q$OLD/\E#$NEW/#g; s#\"\Q$OLD\E\"#\"$NEW\"#g" "$json"
  done
  msg "✅ Done. Backups end in .bak-$STAMP"
else
  msg "(dry run: nothing written)"
fi
