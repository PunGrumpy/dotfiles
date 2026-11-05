function cdgr --description "cd to the git repository root"
    set -l root (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$root"
        echo "Not inside a git repository" >&2
        return 1
    end
    cd $root
end
