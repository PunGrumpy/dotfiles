-- Split a pane. Beside an ssh pane, the new pane logs in to the same host.
-- keybindings.lua binds it with the other pane keys.

local ssh_pane = require("ssh_pane")

local SHELL_FLAVOR = "com.superlogical.terminal.shell"
local SPLITS = { right = "horizontal", down = "vertical" }

rex.action{
  name        = "split_ssh",
  title       = "Split Pane, Same SSH Host",
  description = "Split the pane. Beside an ssh pane, the new pane runs the same ssh, without its port forwards. An ssh with a remote command gets an ordinary split.",
  category    = "SSH",
  keywords    = "ssh split pane host",
  args        = {
    type = "object",
    properties = { direction = { type = "string", enum = { "right", "down" } } },
    additionalProperties = false,
  },
  run         = function(ctx, args)
    local direction = args.direction or "right"
    -- With ctx.server set the pane is on another machine, where ps here sees nothing.
    local ssh = ctx.server == nil and ssh_pane.of(ctx.block_id)
    if not (ssh and ssh.argv) then
      rex.client.queue("pane.split", { direction = direction })
      return
    end

    -- No shell = "none": ssh needs the login shell's SSH_ASKPASS.
    local split, err = rex.session.new_split{
      anchor_id = ctx.block_id,
      direction = SPLITS[direction],
      side      = "after",
      focus     = true,
      layout    = rex.layout.block{
        flavor  = SHELL_FLAVOR,
        options = { command = ssh.argv, cwd = ssh.cwd },
      },
    }
    if err ~= nil then error(err, 0) end
    return { block_ids = split.block_ids }
  end,
}
