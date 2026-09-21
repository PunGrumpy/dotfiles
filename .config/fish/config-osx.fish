# Homebrew
for brew_prefix in /opt/homebrew /usr/local $HOME/homebrew
    if test -x $brew_prefix/bin/brew
        eval ($brew_prefix/bin/brew shellenv fish)
        break
    end
end
set -e brew_prefix

# Inkdrop
set -gx INKDROP_HOME ~/.inkdrop

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
