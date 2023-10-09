if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

if type -q kubectl
    alias k kubectl
end

if type -q kubectx
    alias kx kubectx
    alias kns kubens
end

if test -n "$WSL_DISTRO_NAME"
    alias open xdg-open
    alias c: "cd /mnt/c"
    alias d: "cd /mnt/d"
    alias python python3
end
