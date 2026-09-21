function gdw --description "Remove the current git worktree and delete its branch"
    argparse 'f/force' -- $argv
    or return 1

    set -l force
    set -q _flag_force; and set force --force

    set -l wt (git rev-parse --show-toplevel 2>/dev/null)
    if test -z "$wt"
        echo "Not inside a git repository" >&2
        return 1
    end

    set -l main (git worktree list | grep '\[main\]' | awk '{print $1}')
    if test -z "$main"
        echo "No worktree is checked out on main" >&2
        return 1
    end

    if test "$wt" = "$main"
        echo "Refusing to remove the main worktree" >&2
        return 1
    end

    set -l name (basename $wt)
    git worktree remove $force "$wt"
    and cd "$main"
    and git branch -D "$git_branch_prefix/$name"
end
