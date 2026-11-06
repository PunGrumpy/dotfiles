# Windows

![PowerShell with the Starship prompt in Windows Terminal](../images/powershell.png)

Windows gets the terminal setup only. Development tools and the Git config stay in WSL. Windows Terminal is the terminal until [Rex](https://www.superlogical.com/rex) supports Windows.

## Install

Run the Windows commands in the [main README](../README.md#install). `chezmoi apply` then does the rest:

- winget installs PowerShell, Windows Terminal, WSL, and 1Password.
- Scoop installs Starship, eza, fzf, PSFzf, and GeistMono Nerd Font.
- `$PROFILE` loads `~/.config/powershell/user_profile.ps1` for `pwsh` and for `powershell`, even when OneDrive moves your `Documents` folder.

## Keep a Windows Terminal change

chezmoi manages the Windows Terminal `settings.json`. After you change a setting in the app, run `chezmoi re-add` to keep the change.
