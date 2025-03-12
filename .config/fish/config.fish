# Disable fish greeting
set fish_greeting ""

# Set terminal type
set -gx TERM xterm-256color

# Customize terminal title with directory name and SSH indicator
function fish_title
    set -l title (basename (pwd))
    if test -n "$SSH_CONNECTION"
        set title "$title (SSH) 👻"
    end
    echo -n "$title"
end

# Theme settings
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# Aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias vim nvim

# Set default editor
set -gx EDITOR nvim

# Add custom bin directories to PATH
set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# Node
set -gx PATH node_modules/.bin $PATH

# Yarn
set -gx PATH $HOME/.yarn/bin $PATH

# Bun
set -gx PATH $HOME/.bun/bin $PATH

# Pnpm
set -gx PATH $HOME/.pnpm-global/bin $PATH

# Deno
set -gx PATH $HOME/.deno/bin $PATH

# Go
set -gx GOPATH $HOME/.go
set -gx PATH $GOPATH/bin $PATH

# Cargo
set -gx PATH $HOME/.cargo/bin $PATH

# Ruby
status --is-interactive; and rbenv init - --no-rehash fish | source

# Load OS-specific configurations
switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

# Load local configurations if available
set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

# Load additional aliases configuration
source (dirname (status --current-filename))/config-aliases.fish
