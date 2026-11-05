function sshload --description "Load every SSH key in 1Password into ssh-agent (memory only)"
    if not type -q op
        echo "op not found" >&2
        return 1
    end

    set -l token (op signin --raw); or return 1

    set -l refs (op item list --categories 'SSH Key' --format json --session $token |
        jq -r '.[] | "op://\(.vault.id)/\(.id)/private key?ssh-format=openssh"')
    if test (count $refs) -eq 0
        echo "no SSH keys in 1Password" >&2
        return 1
    end

    for ref in $refs
        op read --session $token $ref | tr -d '\r' | ssh-add -q -
    end
    ssh-add -l
end
