function gwt --description "Create a git worktree branched off origin/main"
    argparse 'b/branch=' -- $argv
    or return 1

    if test (count $argv) -gt 0
        echo "Unknown option: $argv[1]" >&2
        echo "Usage: gwt [--branch <branch-name>]" >&2
        return 1
    end

    set -l branch $_flag_branch
    set -l name

    if test -z "$branch"
        read -P "What are you building? " -l desc
        if test -z "$desc"
            echo "No description provided, aborting." >&2
            return 1
        end

        if type -q ai
            set name (ai -m openai/gpt-4o-mini "Generate a short git branch name (2-4 words, kebab-case, no prefix) for: $desc. Output ONLY the branch name, nothing else." | string trim)
        end

        if test -z "$name"
            set -l words (string lower -- $desc | string replace -ra '[^a-z0-9]+' ' ' | string trim | string split ' ')
            set -l n (count $words)
            test $n -gt 4; and set n 4
            set name (string join '-' $words[1..$n])
        end

        set branch "$git_branch_prefix/$name"
    else
        set name (string split -r -m1 '/' -- $branch)[-1]
    end

    echo "Fetching origin/main..."
    git fetch origin main -q
    and git worktree add -B "$branch" "../$name" origin/main
    and cd "../$name"
end
