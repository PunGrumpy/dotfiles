# Homebrew
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# WSL
if test -n "$WSL_DISTRO_NAME"
    alias open wslview
    alias c: "cd /mnt/c"
    alias d: "cd /mnt/d"

    # 1Password SSH agent
    if type -q ssh.exe
        alias ssh ssh.exe
        alias ssh-add ssh-add.exe
        set -gx GIT_SSH_COMMAND ssh.exe
        set -l op_sign (command -s op-ssh-sign-wsl.exe)
        if test -n "$op_sign"
            set -gx GIT_CONFIG_COUNT 1
            set -gx GIT_CONFIG_KEY_0 gpg.ssh.program
            set -gx GIT_CONFIG_VALUE_0 $op_sign
        end
    end

    # Cursor
    set -gx PATH /mnt/c/Users/$NAME/AppData/Local/Programs/cursor/resources/app/bin $PATH

    # Code
    set -gx PATH /mnt/c/Users/$NAME/AppData/Local/Programs/Microsoft\ VS\ Code/bin $PATH
end
