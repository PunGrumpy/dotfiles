set fish_greeting ""

set -gx TERM xterm-256color

# set title terminal and add 👻 emoji
function fish_title
    set -l title (basename (pwd))
    if test -n "$SSH_CONNECTION"
        set title "$title (SSH) 👻"
    end
    echo -n "$title"
end

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
alias vim nvim
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# Config for OS
switch (uname)
    case Darwin
        source (dirname (status --current-filename))/config-osx.fish
    case Linux
        source (dirname (status --current-filename))/config-linux.fish
    case '*'
        source (dirname (status --current-filename))/config-windows.fish
end

set LOCAL_CONFIG (dirname (status --current-filename))/config-local.fish
if test -f $LOCAL_CONFIG
    source $LOCAL_CONFIG
end

# Node
set -gx PATH node_modules/.bin $PATH

# Yarn
set -gx PATH $HOME/.yarn/bin $PATH

# Bun
set -gx PATH $HOME/.bun/bin $PATH

# Pnpm
set -gx PATH $HOME/.pnpm-global/bin $PATH

# Go
set -gx GOPATH $HOME/.go

# Cargo
set -gx PATH $HOME/.cargo/bin $PATH

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
    status --is-command-substitution; and return

    if test -f .nvmrc; and test -r .nvmrc
        nvm use
    end
end

# Aliases Config
source (dirname (status --current-filename))/config-aliases.fish
