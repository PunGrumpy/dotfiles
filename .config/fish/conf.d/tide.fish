# Lean, Geist-style prompt: no segment backgrounds, gray metadata, white command
for v in (set --names | string match --regex '^tide_\w+_color(_\w+)?$' | string match --invert --regex 'separator|prompt_color')
    set -g $v 878787
end
for v in (set --names | string match --regex '^tide_\w+_bg_color(_\w+)?$')
    set -g $v normal
end

set -g tide_left_prompt_prefix ''
set -g tide_left_prompt_suffix ''
set -g tide_left_prompt_separator_diff_color ' '
set -g tide_left_prompt_separator_same_color ' '
set -g tide_right_prompt_prefix ''
set -g tide_right_prompt_suffix ''
set -g tide_right_prompt_separator_diff_color ' '
set -g tide_right_prompt_separator_same_color ' '
set -g tide_prompt_pad_items false

set -g tide_character_icon ❯
set -g tide_character_vi_icon_default ❯
set -g tide_character_color ededed
set -g tide_character_color_failure f13242

set -g tide_pwd_color_anchors a0a0a0
set -g tide_pwd_color_dirs 878787
set -g tide_pwd_color_truncated_dirs 878787

set -g tide_git_icon
set -g tide_git_color_branch a0a0a0
set -g tide_git_color_dirty ffae00
set -g tide_git_color_staged ffae00
set -g tide_git_color_untracked ffae00
set -g tide_git_color_conflicted f13242
set -g tide_git_color_operation f13242

set -g tide_status_color 00ca50
set -g tide_status_color_failure f13242

set -g tide_docker_icon 󰡨
set -g tide_kubectl_icon 󱃾
