function update --description "Update system packages and developer tooling"
    if type -q apt
        sudo -v; or return 1
        sudo apt update -y
        sudo apt full-upgrade -y
        sudo apt autoremove --purge -y
        sudo apt autoclean -y
    end

    if type -q brew
        brew update; and brew upgrade; and brew cleanup
    end

    type -q fisher; and fisher update

    if type -q bun
        bun update -g --latest
        bunx skills update -g
    end
end
