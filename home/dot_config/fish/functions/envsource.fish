function envsource --description "Export the KEY=value lines of a file"
    for line in (grep -v '^#' $argv)
        set -l item (string split -m 1 '=' $line)
        set -gx $item[1] $item[2]
        echo "Exported key $item[1]"
    end
end
