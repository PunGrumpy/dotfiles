function cpwd --description "Copy \$PWD to the clipboard without a trailing newline"
    printf '%s' "$PWD" | clipcopy
end
