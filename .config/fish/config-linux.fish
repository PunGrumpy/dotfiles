# Homebrew
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# WSL
if test -n "$WSL_DISTRO_NAME"
    alias open wslview
    alias c: "cd /mnt/c"
    alias d: "cd /mnt/d"

    # Cursor
    set -gx PATH /mnt/c/Users/$NAME/AppData/Local/Programs/cursor/resources/app/bin $PATH

    # Code
    set -gx PATH /mnt/c/Users/$NAME/AppData/Local/Programs/Microsoft\ VS\ Code/bin $PATH
end
