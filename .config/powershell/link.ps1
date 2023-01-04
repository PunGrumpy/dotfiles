# Windows Terminal

# Check oh-my-posh is installed and ask to install it if not
if (!(Get-Module oh-my-posh -ListAvailable)) {
    Write-Host "Oh My Posh is not installed. Do you want to install it? (y/n)"
    $answer = Read-Host
    if ($answer -eq "y") {
        winget install JanDeDobbeleer.OhMyPosh --scope user
        Install-Module posh-git -Scope CurrentUser
    } else {
        Write-Host "Oh My Posh is not installed. You can install it later."
    }
}

# Check current path is the dotfiles/.config/powershell folder and ask to change it if not
if ((Get-Location).Path -ne (Get-Location).Path + "\.dotfiles\.config\powershell") {
    Write-Host "You are not in the dotfiles/.config/powershell folder. Do you want to change it? (y/n)"
    $answer = Read-Host
    if ($answer -eq "y") {
        cd .dotfiles\.config\powershell
    } else {
        Write-Host "You are not in the dotfiles/.config/powershell folder. You can change it later."
    }
}

# Function link
Link() {
    $source = $args[0]
    $target = $args[1]

    if (Test-Path $target) {
        Remove-Item $target
    }

    New-Item -ItemType SymbolicLink -Path $target -Value $source
}

# Create a symbolic link to the profile file
# New-Item -ItemType SymbolicLink -Path $PROFILE -Value ".dotfiles\.config\powershell\Microsoft.PowerShell_profile.ps1"
Link (Get-Location).Path + "\Microsoft.PowerShell_profile.ps1" $PROFILE 

# Create a symbolic link to the theme of Oh My Posh
# New-Item -ItemType SymbolicLink -Path $env:POSH_THEMES_PATH -Value ".dotfiles\.config\powershell\grumpy.omp.json"
Link (Get-Location).Path + "\grumpy.omp.json" $env:POSH_THEMES_PATH

# Create a symbolic link to the theme of Windows Terminal
# New-Item -ItemType SymbolicLink -Path $env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json -Value ".dotfiles\.config\windows-terminal\settings.json"
Link (Get-Location).Path + "\settings.json" "$env:LOCALAPPDATA\Microsoft\Windows Terminal\settings.json"