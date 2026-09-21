set -q git_branch_prefix; or set -g git_branch_prefix pungrumpy

# Bun
set -gx BUN_INSTALL $HOME/.bun

# OpenCode
fish_add_path -g $HOME/.opencode/bin

# fnm
set -gx FNM_LOGLEVEL quiet

