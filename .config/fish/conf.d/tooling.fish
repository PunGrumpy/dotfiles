set -q git_branch_prefix; or set -g git_branch_prefix pungrumpy

# Bun
set -gx BUN_INSTALL $HOME/.bun

# OpenCode
fish_add_path -g $HOME/.opencode/bin

# fnm
set -gx FNM_LOGLEVEL quiet

# Eza
set -gx EZA_CONFIG_DIR $HOME/.config/eza
set -gx EZA_COLORS (string join ':' \
    '*.html=38;2;71;168;255' '*.htm=38;2;71;168;255' \
    '*.vue=38;2;71;168;255' '*.svelte=38;2;71;168;255' \
    '*.toml=38;2;255;174;0' '*.yml=38;2;255;174;0' '*.yaml=38;2;255;174;0' \
    '*.ini=38;2;255;174;0' '*.conf=38;2;255;174;0' '*.cfg=38;2;255;174;0' \
    '*.env=38;2;255;174;0' '*.lock=38;2;255;174;0' \
    '*.md=38;2;255;174;0' '*.rst=38;2;255;174;0' '*.xml=38;2;255;174;0' \
    '*.json=38;2;255;174;0' '*.csv=38;2;255;174;0' '*.tsv=38;2;255;174;0' \
    '*.tsx=38;2;0;172;58' '*.jsx=38;2;0;172;58' \
    '*.sh=38;2;0;172;58' '*.fish=38;2;0;172;58' '*.bash=38;2;0;172;58' '*.zsh=38;2;0;172;58' \
    README.md=0 package.json=0 Makefile=0 Cargo.toml=0 go.mod=0)
