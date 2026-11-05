# 👧 PowerShell

**PowerShell** is a cross-platform task automation and configuration management framework, consisting of a command-line shell and scripting language.

## 📦 Setup

1. Install [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
2. Install Terminal [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal)
3. Install Theme Configuration (Choose one)
   - Install [oh-my-posh](https://ohmyposh.dev/docs/installation) (Not updated anymore)
   - Install [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation) (Recommended)
4. Install [Nerd Fonts](https://www.nerdfonts.com/font-downloads) (Recommended: Hack Nerd Font)
5. Run `chezmoi init --apply PunGrumpy`. It writes the profile for `pwsh` and `powershell` to `Documents`, and to `OneDrive\Documents` when that folder exists. Windows gets the shell config, the Git config and the mise runtimes. Neovim runs without the config, and the other development tools stay in WSL.

> [!NOTE]
> I've customize color scheme for Windows Terminal, you can find it in `windows/settings.json` file.
> If you want to use it, you can copy the content and replace it with your settings.json file.
