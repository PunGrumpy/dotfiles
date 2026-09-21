set -l tide_theme $__fish_config_dir/tide/$DOTFILES_THEME.fish
if test -f $tide_theme
    source $tide_theme
end
