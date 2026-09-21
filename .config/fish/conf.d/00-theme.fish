if not set -q DOTFILES_THEME
    if set -q WSL_DISTRO_NAME
        set -g DOTFILES_THEME solarized-osaka
    else
        set -g DOTFILES_THEME vercel
    end
end

set -gx DOTFILES_THEME $DOTFILES_THEME
