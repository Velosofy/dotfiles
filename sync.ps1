
function Write-Part ([string] $Text) {
    Write-Host $Text -NoNewline
}
  
function Write-Emphasized ([string] $Text) {
    Write-Host $Text -NoNewLine -ForegroundColor "Cyan"
}
  
function Write-Done {
    Write-Host " > " -NoNewline
    Write-Host "OK" -ForegroundColor "Green"
}

function Write-NG {
    Write-Host " > " -NoNewline
    Write-Host "ERROR" -ForegroundColor "Red"
}

$items = @{
    "$HOME\.config\ripgrep.conf"  = ".\.config\ripgrep.conf"
    "$HOME\.config\starship.toml" = ".\.config\starship.toml"
    "$PROFILE"                    = ".\win\Microsoft.PowerShell_profile.ps1"
}

foreach ($item in $items.GetEnumerator()) {
    try {
        Write-Part "Copying "
        Write-Emphasized $(Split-Path -Leaf $item.Key)
        Copy-Item -Path $item.key -Destination $item.value -ErrorAction Stop
        Write-Done
    }
    catch {
        Write-NG
        Write-Host (' ' + $_.Exception.Message)
    }
}

