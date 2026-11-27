# Rex keeps theme, font and appearance in app settings, not in init.lua.
# This script writes those settings on a new Windows machine. ~/.scripts/rex does the same on macOS.
$ErrorActionPreference = 'Stop'

$app = Join-Path $env:LOCALAPPDATA 'Superlogical\Rex'
$rex = Join-Path $app 'rex.com'
if (-not (Test-Path -LiteralPath $rex)) {
  Write-Host "Skipping Rex configuration; $app not found (download it from https://www.superlogical.com/rex)"
  exit 0
}

# Rex takes the setting actions below only with remote control on, and reads that at launch.
# Rex warns that config.ini will go away, but it is the one place to set this before launch.
$ini = Join-Path $app 'config.ini'
$text = if (Test-Path -LiteralPath $ini) { Get-Content -Raw -LiteralPath $ini } else { '' }
if ($text -notmatch '(?m)^\s*remote_control\s*=\s*true') {
  if ($text -match '(?m)^\[client\]\r?$') {
    $text = $text -replace '(?m)^\[client\]\r?$', "[client]`r`nremote_control = true"
  } else {
    $text += "`r`n[client]`r`nremote_control = true`r`n"
  }
  Set-Content -LiteralPath $ini -Value $text -NoNewline
}

# Restart the app so it reads config.ini. Sessions live on the server and survive.
Get-Process -Name rex -ErrorAction SilentlyContinue |
  Where-Object { $_.Path -eq (Join-Path $app 'rex.exe') } |
  ForEach-Object { $_.CloseMainWindow() | Out-Null; $_.WaitForExit(5000) | Out-Null }
Start-Process (Join-Path $app 'rex.exe')

$client = $null
foreach ($attempt in 1..20) {
  Start-Sleep -Seconds 1
  $client = (& $rex client ls --json 2>$null | ConvertFrom-Json).clients |
    Where-Object { $_.info.kind -eq 'app' -and $_.connection_state -eq 'connected' } |
    Select-Object -Last 1 -ExpandProperty client_id
  if ($client) { break }
}
if (-not $client) {
  Write-Host "Rex app did not connect; turn on Settings > Client: Remote Control and run this script again"
  exit 1
}

function Set-RexSetting($name, $value) {
  & $rex -C $client do "client.setting.$name" "value=$value" | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "rex could not set $name" }
}

Write-Host 'Configuring Rex settings...'
# Windows names the Nerd Font Mono variant GeistMono NFM.
Set-RexSetting font_family 'GeistMono NFM'
Set-RexSetting font_size 12
Set-RexSetting font_ligatures false
Set-RexSetting cursor_style block
Set-RexSetting cursor_blink false
Set-RexSetting theme dark
Set-RexSetting pane_header_visibility never
Set-RexSetting inactive_pane_dim_amount 0
# New tabs open fish in WSL, where the development tools live.
Set-RexSetting default_shell wsl

# An import selects the theme for its appearance, dark or light.
foreach ($theme in Get-ChildItem (Join-Path $HOME '.config\rex\themes') -Filter *.ghostty) {
  & $rex -C $client do client.theme.import "path=$($theme.FullName)" | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "rex could not import $($theme.Name)" }
  Write-Host "Imported theme $($theme.BaseName)"
}

& $rex config reload | Out-Null
Write-Host 'Rex configured.'
