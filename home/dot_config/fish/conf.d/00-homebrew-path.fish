# Plugins in conf.d look up Homebrew tools before config.fish runs.
# macOS gets this path from /etc/paths.d/homebrew. Linux has no equivalent.
fish_add_path -g --path /home/linuxbrew/.linuxbrew/bin
