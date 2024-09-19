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

# Clear PowerShell logo
Clear-Host
