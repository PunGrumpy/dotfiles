# Windows

![Neovim on WSL and PowerShell in Rex on Windows](../images/rex-windows.png)

Windows gets the terminal setup only. Development tools and the Git config stay in WSL. [Rex](https://www.superlogical.com/rex) is the terminal, with the same keys and actions as on macOS. Windows Terminal stays set up as a second terminal.

## Install

Run the Windows commands in the [main README](../README.md#install). `chezmoi apply` then does the rest:

- winget installs PowerShell, Windows Terminal, WSL, and 1Password.
- Scoop installs Starship, eza, fzf, PSFzf, and GeistMono Nerd Font.
- `$PROFILE` loads `~/.config/powershell/user_profile.ps1` for `pwsh` and for `powershell`, even when OneDrive moves your `Documents` folder.

## Set up Rex

1. Download [Rex](https://www.superlogical.com/rex) and open it once.
2. Run `~/.scripts/rex.ps1` to set the font, cursor, Vercel themes, and the WSL shell. The script restarts Rex. Your sessions survive.
3. Run `rex server install --user -- --tailscale` to start the Rex server, with Tailscale, each time you sign in. It needs no password and no administrator rights.

Without `--user`, Rex installs a Windows Service that starts at boot and asks for the password of your Microsoft account. With "Only allow Windows Hello sign-in for Microsoft accounts" on, the PC may not have your current password, and Windows refuses it. This setup uses `--user` instead. The server then stops when you sign out. `rex server uninstall` removes it.

Rex for Windows reads `%AppData%\rex\init.lua`. That file loads `~/.config/rex`, the same config as on macOS. The actions that run lazygit, nvim, and Claude Code start them in WSL, in the folder of the focused pane. Sync typing and sshpick are macOS only.

Rex for Windows 0.1.1-snapshot.520 does not use the key bindings in `init.lua`. `ctrl+a>l` and the other keys in `keybindings.lua` do nothing, and the command palette does not list the actions. Run an action from a Rex pane instead, for example `rex.com do lazygit` in WSL or `rex do lazygit` in PowerShell. The keys Rex for Windows has itself work, such as Ctrl+Shift+T for a new tab and Ctrl+Shift+W to close a pane.

## Keep a Windows Terminal change

chezmoi manages the Windows Terminal `settings.json`. After you change a setting in the app, run `chezmoi re-add` to keep the change.
