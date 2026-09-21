function clipcopy --description "Copy stdin to the system clipboard"
    if type -q pbcopy
        pbcopy
    else if type -q wl-copy
        wl-copy
    else if type -q xclip
        xclip -selection clipboard
    else
        cat >/dev/null
        echo "No clipboard tool found" >&2
        return 1
    end
end
