if type -q eza
    alias ll "eza -l -g --icons"
    alias lla "ll -a"
end

if type -q kubectl
    alias k kubectl
end

if type -q kubectx
    alias kctx kubectx
    alias kns kubens
end

# Inkdrop
set -gx INKDROP_HOME ~/.inkdrop

# Fzf
set -g FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always --line-range :500"
set -g FZF_LEGACY_KEYBINDINGS 0
