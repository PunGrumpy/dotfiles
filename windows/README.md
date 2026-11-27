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

Rex for Windows reads `%AppData%\rex\init.lua`. That file loads `~/.config/rex`, the same config as on macOS. The actions that run lazygit, nvim, and Claude Code start them in WSL, in the folder of the focused pane. Sync typing and sshpick are macOS only.

## Keep a Windows Terminal change

chezmoi manages the Windows Terminal `settings.json`. After you change a setting in the app, run `chezmoi re-add` to keep the change.
