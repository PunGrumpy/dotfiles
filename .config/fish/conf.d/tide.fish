set -g tide_left_prompt_items pwd git newline character
set -g tide_right_prompt_items status cmd_duration jobs node time

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

set -g tide_pwd_bg_color normal
set -g tide_pwd_color_anchors a0a0a0
set -g tide_pwd_color_dirs 878787
set -g tide_pwd_color_truncated_dirs 878787

set -g tide_git_icon
set -g tide_git_bg_color normal
set -g tide_git_bg_color_unstable normal
set -g tide_git_bg_color_urgent normal
set -g tide_git_color_branch a0a0a0
set -g tide_git_color_upstream 878787
set -g tide_git_color_stash 878787
set -g tide_git_color_dirty ffae00
set -g tide_git_color_staged ffae00
set -g tide_git_color_untracked ffae00
set -g tide_git_color_conflicted f13242
set -g tide_git_color_operation f13242

set -g tide_status_bg_color normal
set -g tide_status_bg_color_failure normal
set -g tide_status_color 00ca50
set -g tide_status_color_failure f13242

set -g tide_cmd_duration_bg_color normal
set -g tide_cmd_duration_color 878787

set -g tide_jobs_bg_color normal
set -g tide_jobs_color 878787

set -g tide_node_bg_color normal
set -g tide_node_color 878787

set -g tide_time_bg_color normal
set -g tide_time_color 878787
