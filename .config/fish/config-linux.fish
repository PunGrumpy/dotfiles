# Homebrew
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# WSL
if test -n "$WSL_DISTRO_NAME"
    alias open wslview
    alias c: "cd /mnt/c"
    alias d: "cd /mnt/d"

    # Remove cursor from PATH (it's a symlink to /mnt/c/Users/PunGrumpy/AppData/Local/Programs/cursor/resources/app/bin)
    set -gx PATH (string match -v '/mnt/c/Users/PunGrumpy/AppData/Local/Programs/cursor/resources/app/bin' $PATH)
end
