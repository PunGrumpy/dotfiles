# 👧 PowerShell

**PowerShell** is a cross-platform task automation and configuration management framework, consisting of a command-line shell and scripting language.

## 📦 Setup

1. Install [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
2. Install Terminal [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal)
3. Install Theme Configuration (Choose one)
   - Install [oh-my-posh](https://ohmyposh.dev/docs/installation) (Not updated anymore)
   - Install [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation) (Recommended)
4. Install [Nerd Fonts](https://www.nerdfonts.com/font-downloads) (Recommended: Hack Nerd Font)
5. Run `chezmoi init --apply PunGrumpy`. The profile is `~/.config/powershell/user_profile.ps1`, and chezmoi makes `$PROFILE` load it for `pwsh` and `powershell`, including when OneDrive moves your `Documents` folder. Windows gets the terminal appearance only: Windows Terminal, the PowerShell profile, Starship, eza and the font. Development tools and the Git config stay in WSL.

> [!NOTE]
> chezmoi manages the Windows Terminal `settings.json`. After you change a setting in the app, run `chezmoi re-add` to keep the change.
