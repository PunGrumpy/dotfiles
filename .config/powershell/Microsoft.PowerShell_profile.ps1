# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Load prompt config
# oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\grumpy.omp.json" | Invoke-Expression
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
function LSColor {
    param(
        [switch]$All
    )
    if ($All) {
        eza -l --icons --color -a
    } else {
        eza -l --icons --color
    }
}

# Aliases
Set-Alias vim nvim
Set-Alias ls eza
Set-Alias ll LSColor
function lla { LSColor -All }
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias wget iwr

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Clear PowerShell logo
Clear-Host

