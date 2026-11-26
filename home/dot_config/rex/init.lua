-- Theme, font and padding live in Rex Settings. .scripts/rex sets them.
-- Each file beside this one holds one concern. Add new ones here.

-- sync_panes and ssh_pane live in the rex-sync repository. run_after_45-update-rex-sync.sh clones it.
package.path = os.getenv("HOME") .. "/.local/share/rex-sync/packages/sync-typing/lua/?.lua;" .. package.path

-- For a module from another repository, so a machine without that repository still loads this file.
local function optional(name)
  local ok, err = pcall(require, name)
  if not ok and not tostring(err):find("module " .. name .. " not found", 1, true) then
    error(err, 0)
  end
  return ok
end

require("keybindings")
require("lazygit")
require("claude")
require("copy_mode")
require("split_ssh")

-- sshpick: pick a host in a floating layer, open it in a labelled tab. See sshpick's docs/rex.md.
-- It is linked in by hand.
if optional("sshpick") then
  rex.bind("ctrl+a>s", "sshpick")
end

-- Last, because it leaves the keys bound above to their own actions.
optional("sync_panes")
