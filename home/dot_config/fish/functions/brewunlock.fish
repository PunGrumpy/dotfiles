function brewunlock --description "Remove stale Homebrew lock files left behind by an interrupted brew"
    if not type -q brew
        echo "brew not found" >&2
        return 1
    end

    if pgrep -f 'brew\.rb|build\.rb' >/dev/null 2>&1
        echo "brew is still running, refusing to clear its locks:" >&2
        pgrep -fl 'brew\.rb|build\.rb' >&2
        return 1
    end

    set -l dir (brew --prefix)/var/homebrew/locks
    if not test -d $dir
        echo "no lock directory at $dir"
        return 0
    end

    set -l stale $dir/*.lock
    if test (count $stale) -eq 0
        echo "no stale locks"
        return 0
    end

    for f in $stale
        echo "  "(path basename $f)
    end
    rm -f $stale
    echo "cleared "(count $stale)" stale lock(s)"
end
