##################################################
# Import Modules
##################################################

# ChildItemColor 
if (Get-Module -ListAvailable -Name Get-ChildItemColor) {
    Import-Module Get-ChildItemColor
} else {
    Install-Module Get-ChildItemColor -Scope CurrentUser
    Import-Module Get-ChildItemColor
}

# PSReadLine
if (Get-Module -ListAvailable -Name psreadline) {
    Import-Module psreadline
} else {
    Install-Module psreadline -Scope CurrentUser
    Import-Module psreadline
}

# Posh-Git
if (Get-Module -ListAvailable -Name posh-git) {
    Import-Module posh-git
} else {
    Install-Module posh-git -Scope CurrentUser
    Import-Module posh-git
}

# Chocolatey profile
if (Test-Path("$env:ChocolateyInstall\helpers\chocolateyProfile.psm1")) {
  Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
}

##################################################
# Functions & Aliases
##################################################

function prompt {
    # Store Current LastExitCode (incase this function changes it)
    $realLASTEXITCODE = $LASTEXITCODE
    
    # Add Empty Line To Seperate From Previous Command Output
    Write-Host

    # color for PSSessions
    if ($s -ne $null) {
        Write-Host "[$($s.Name)]" -NoNewline -ForegroundColor Red
    }
    else {
        Write-Host "[$ENV:COMPUTERNAME]" -NoNewline -ForegroundColor Yellow
    }

    Write-Host "[$ENV:USERNAME]" -NoNewline -ForegroundColor Green
    Write-Host "[$(Get-Location)]" -NoNewline -ForegroundColor Magenta
    Write-VcsStatus
    Write-Host
    return "> "

    # Restore LastExitCode
    $global:LASTEXITCODE = $realLASTEXITCODE
}

# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias l Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope

# Helper function to set location to the User Profile directory
function cuserprofile { Set-Location ~ }
Set-Alias ~ cuserprofile -Option AllScope

# Helper function to show Unicode character
function U
{
    param
    (
        [int] $Code
    )
 
    if ((0 -le $Code) -and ($Code -le 0xFFFF))
    {
        return [char] $Code
    }
 
    if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
    {
        return [char]::ConvertFromUtf32($Code)
    }
 
    throw "Invalid character code $Code"
}

# Quick Delete
Set-Alias trash Remove-ItemSafely

##################################################
# Settings
##################################################

# Set Max History To Store
$MaximumHistoryCount = 10000;

# Produce UTF-8 by default
$PSDefaultParameterValues["Out-File:Encoding"] = "utf8"
