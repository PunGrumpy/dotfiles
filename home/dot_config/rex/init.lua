-- Theme, font and padding live in Rex Settings. .scripts/rex sets them.
-- Each file beside this one holds one concern. Add new ones here.

require("keybindings")
require("lazygit")
require("claude")
require("copy_mode")
require("split_ssh")

-- sshpick: pick a host in a floating layer, open it in a labelled tab. See sshpick's docs/rex.md.
-- It lives in its own repo and is linked in by hand, so a machine without it still loads this file.
local ok, err = pcall(require, "sshpick")
if ok then
  rex.bind("ctrl+a>s", "sshpick")
elseif not tostring(err):find("module sshpick not found", 1, true) then
  error(err, 0)
end

-- Last, because it leaves the keys bound above to their own actions.
require("sync_panes")
