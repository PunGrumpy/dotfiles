# Homebrew
for brew_prefix in /opt/homebrew /usr/local $HOME/homebrew
    if test -x $brew_prefix/bin/brew
        eval ($brew_prefix/bin/brew shellenv fish)
        break
    end
end
set -e brew_prefix

# Homebrew casks
if not id -Gn | string match -qr '\badmin\b'
    set -gx HOMEBREW_CASK_OPTS "--appdir=$HOME/Applications"
end

# 1Password SSH agent
set -l op_agent "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
if test -S $op_agent
    set -gx SSH_AUTH_SOCK $op_agent
end

# Inkdrop
set -gx INKDROP_HOME ~/.inkdrop

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
