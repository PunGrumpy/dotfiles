# 👧 PowerShell

**PowerShell** is a cross-platform task automation and configuration management framework, consisting of a command-line shell and scripting language.

## 📦 Setup

1. Install [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
2. Install Terminal [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal)
3. Install Theme Configuration (Choose one)
   - Install [oh-my-posh](https://ohmyposh.dev/docs/installation) (Not updated anymore)
   - Install [Starship](https://starship.rs/guide/#%F0%9F%9A%80-installation) (Recommended)
4. Install [Nerd Fonts](https://www.nerdfonts.com/font-downloads) (Recommended: Hack Nerd Font)
5. Link the profile to this repo, so `git pull` is all it takes to update it

   ```powershell
   $repo = "$HOME\.dotfiles\.config\windows\powershell\Microsoft.PowerShell_profile.ps1"
   New-Item -ItemType SymbolicLink -Path $PROFILE -Target $repo -Force
   ```

   > [!IMPORTANT]
   > Creating a symlink needs Developer Mode enabled (Settings -> System -> For developers)
   > or an elevated shell. Run it once per host (`pwsh` and `powershell` have separate
   > `$PROFILE` paths).

> [!NOTE]
> I've customize color scheme for Windows Terminal, you can find it in `.config/windows/settings.json` file.
> If you want to use it, you can copy the content and replace it with your settings.json file.
