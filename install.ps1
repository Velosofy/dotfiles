$baseurl = "https://raw.githubusercontent.com/Velosofy/dotfiles/master"

if (!(Get-Command scoop)) {
    Write-Host "Installing Scoop..."
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}
else {
    scoop update
}

scoop install main/git
scoop bucket add extras

scoop install main/wget
scoop install main/aria2
scoop install main/ripgrep
scoop install main/fzf
scoop install main/bat
scoop install extras/lazygit

if (!(Get-Command winget)) {
    Write-Warning "winget is not installed. Installing using scoop..."
    scoop install main/winget
}

$question = 'Do you want to use WinINet for winget? If you''re not sure, select No'
$choices = '&Yes', '&No'
$decision = $Host.UI.PromptForChoice('', $question, $choices, 1)
if ($decision -eq 0) {
    Write-Host "Using WinINet for winget..."
    Invoke-RestMethod -Uri "$baseurl/win/winget-settings.json" -OutFile $env:LOCALAPPDATA\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json
}
else {
    Write-Host "Using Delivery Optimization for winget..."
}

Invoke-RestMethod -Uri "$baseurl/win/apps.json" -OutFile $ENV:TEMP\apps.json
Start-Process -FilePath "pwsh" -ArgumentList "-NoExit -Command winget import -i $ENV:TEMP\apps.json --accept-source-agreements --accept-package-agreements" -Verb RunAs

Install-Module -Name PSReadLine -Scope CurrentUser -Force -AcceptLicense
Install-Module -Name PSFzf -Scope CurrentUser -Force -AcceptLicense

mkdir $HOME\.config -ErrorAction SilentlyContinue
Invoke-RestMethod -Uri "$baseurl/win/Microsoft.PowerShell_profile.ps1" -OutFile $PROFILE
Invoke-RestMethod -Uri "$baseurl/.config/starship.toml" -OutFile $HOME\.config\starship.toml
Invoke-RestMethod -Uri "$baseurl/.config/ripgrep.conf" -OutFile $HOME\.config\ripgrep.conf

Write-Host "Done."
