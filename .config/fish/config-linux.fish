if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

if test -n "$WSL_DISTRO_NAME"
    alias open xdg-open
    alias c: "cd /mnt/c"
    alias d: "cd /mnt/d"
    alias python python3
end
