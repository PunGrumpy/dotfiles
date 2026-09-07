# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Load prompt config
Invoke-Expression (&starship init powershell)

# PSReadLine Configuration
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf Configuration
Import-Module PSFzf
Set-PSFzfOption -PSReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

# LS colors
function Get-LSColor {
    [CmdletBinding()]
    param(
        [switch]$All
    )
    try {
        $ezaCommand = Get-Command eza -ErrorAction Stop
        $ezaArgs = @()
        if ($All) {
            $ezaArgs += '-l', '--icons', '--color', '-a'
        } else {
            $ezaArgs += '-l', '--icons', '--color'
        }
        & $ezaCommand.Path @ezaArgs
    }
    catch {
        Write-Error "eza is not installed or encountered an error: $_"
    }
}

# Aliases
# `ls` ships as an AllScope alias on Windows PowerShell 5.1 and cannot be overridden in place
if (Test-Path alias:ls) { Remove-Item alias:ls -Force }

Set-Alias -Name vim -Value nvim
Set-Alias -Name ls -Value eza
Set-Alias -Name ll -Value Get-LSColor
Set-Alias -Name lla -Value Get-LSColor -Option All
Set-Alias -Name g -Value git
Set-Alias -Name grep -Value findstr
Set-Alias -Name tig -Value "$env:ProgramFiles\Git\usr\bin\tig.exe"
Set-Alias -Name less -Value "$env:ProgramFiles\Git\usr\bin\less.exe"
Set-Alias -Name wget -Value iwr

# Utilities
function mkdir {
    param(
        [string]$Path,
        [switch]$Force,
        [switch]$Recursive
    )
    try {
        $params = @{
            Path = $Path
            ItemType = 'Directory'
            ErrorAction = 'Stop'
        }
        if ($Force) { $params['Force'] = $true }
        New-Item @params | Out-Null
        Write-Output "Directory created: $Path"
    }
    catch {
        Write-Error "Failed to create directory: $_"
    }
}

function rm {
    param(
        [string]$Path,
        [switch]$Force,
        [switch]$Recursive
    )
    try {
        $params = @{
            Path = $Path
            ErrorAction = 'Stop'
        }
        if ($Force) { $params['Force'] = $true }
        if ($Recursive) { $params['Recurse'] = $true }
        Remove-Item @params
        Write-Output "Item removed: $Path"
    }
    catch {
        Write-Error "Failed to remove item: $_"
    }
}

function cp {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$Force,
        [switch]$Recursive
    )
    try {
        $params = @{
            Path = $Source
            Destination = $Destination
            ErrorAction = 'Stop'
        }
        if ($Force) { $params['Force'] = $true }
        if ($Recursive) { $params['Recurse'] = $true }
        Copy-Item @params | Out-Null
        Write-Output "File copied from $Source to $Destination"
    }
    catch {
        Write-Error "Failed to copy file: $_"
    }
}

function mv {
    param(
        [string]$Source,
        [string]$Destination,
        [switch]$Force
    )
    try {
        $params = @{
            Path = $Source
            Destination = $Destination
            ErrorAction = 'Stop'
        }
        if ($Force) { $params['Force'] = $true }
        Move-Item @params | Out-Null
        Write-Output "File moved from $Source to $Destination"
    }
    catch {
        Write-Error "Failed to move file: $_"
    }
}

function touch {
    param(
        [string]$Path,
        [switch]$Force
    )
    try {
        $params = @{
            Path = $Path
            ItemType = 'File'
            ErrorAction = 'Stop'
        }
        if ($Force) { $params['Force'] = $true }
        New-Item @params | Out-Null
        Write-Output "File created: $Path"
    }
    catch {
        Write-Error "Failed to create file: $_"
    }
}

function cat {
    param(
        [string]$Path
    )
    try {
        Get-Content -Path $Path -ErrorAction Stop
    }
    catch {
        Write-Error "Failed to read file: $_"
    }
}

function ln {
    param(
        [string]$Source,
        [string]$Destination
    )
    try {
        New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -ErrorAction Stop | Out-Null
        Write-Output "Symbolic link created from $Source to $Destination"
    }
    catch {
        Write-Error "Failed to create symbolic link: $_"
    }
}

# Update system packages and developer tooling
function Update-System {
    [CmdletBinding()]
    param()

    $useSudo = $null -ne (Get-Command sudo -ErrorAction SilentlyContinue)

    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "==> scoop" -ForegroundColor Cyan
        scoop update --all
        scoop cleanup --all --cache
    }

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "==> winget" -ForegroundColor Cyan
        $wingetArgs = @('upgrade', '--all', '--include-unknown')
        if ($useSudo) { sudo winget @wingetArgs } else { winget @wingetArgs }
    }

    if (Get-Command bun -ErrorAction SilentlyContinue) {
        Write-Host "==> bun" -ForegroundColor Cyan
        bun update -g --latest
        bunx skills update -g
    }
}

Set-Alias -Name update -Value Update-System

# Chocolatey Profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

# Command Not Found (PowerToys / WinGet)
if (Get-Module -ListAvailable -Name Microsoft.WinGet.CommandNotFound) {
    Import-Module -Name Microsoft.WinGet.CommandNotFound
}

# Clear PowerShell logo
Clear-Host
