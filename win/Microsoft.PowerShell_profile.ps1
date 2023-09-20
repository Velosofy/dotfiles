function Invoke-Starship-PreCommand {
    $Host.UI.RawUI.WindowTitle = "$pwd `a"
}
Invoke-Expression (&starship init powershell)

$env:RIPGREP_CONFIG_PATH = "$HOME\.config\ripgrep.conf"
$env:BAT_STYLE = "plain"

# PSReadLine
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

# https://github.com/giggio/posh-alias/blob/master/Posh-Alias.psm1
function Add-Alias($name, $alias) {
    $func = @"
    function global:$name {
        `$expr = ('$alias ' + (( `$args | % { if (`$_.GetType().FullName -eq "System.String") { "``"`$(`$_.Replace('``"','````"').Replace("'","``'"))``"" } else { `$_ } } ) -join ' '))
        write-debug "Expression: `$expr"
        Invoke-Expression `$expr
    }
"@

    Write-Debug "Defined function:`n$func"
    $func | Invoke-Expression
}

Remove-Alias 'ls'
Remove-Alias 'pwd'
Remove-Alias 'cat'

Add-Alias 'ls' 'eza'
Add-Alias 'l' 'eza'
Add-Alias 'll' 'eza -l'
Add-Alias 'lla' 'eza -la'
Add-Alias 'pwd' '(Get-Location).Path'
Add-Alias 'grep' 'rg'
Add-Alias 'cat' 'bat'
Add-Alias 'gs' 'git status'

function ghub {
    git remote get-url origin 2>$null
    if ($LASTEXITCODE -eq 128) {
        Write-Error "$((Get-Location).Path) is not a git repository."
        return
    }

    $url = git remote get-url origin
    if ($url.StartsWith('git@')) {
        $url = $url.Replace(':', '/').Replace('.git', '').Replace('git@', 'https://')
    }
    Start-Process $url
}

function fb {
    Set-Location C:\dev\git\flavor_bistro
}

function Update-Profile {
    . $PROFILE
}

function Edit-Profile {
    code $PROFILE
}

function md5 ($file) {
    Get-FileHash $file -Algorithm MD5 | 
    Select-Object -ExpandProperty Hash
}

function pkill ($process) {
    Get-Process $process | 
    Select-Object -ExpandProperty Id | 
    ForEach-Object { Stop-Process -Id $_ -Force }
}

function which ($command) {
    Get-Command -Name $command | 
    Select-Object -ExpandProperty Path
}

function touch ($name) {
    New-Item $name
}
