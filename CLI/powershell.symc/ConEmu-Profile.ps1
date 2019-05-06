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

# Posh-SShell
if (Get-Module -ListAvailable -Name posh-sshell) {
    Import-Module posh-sshell
} else {
    Install-Module posh-sshell -Scope CurrentUser -AllowClobber
    Import-Module posh-sshell
}

# Oh-My-Posh 
if (Get-Module -ListAvailable -Name oh-my-posh) {
    Import-Module oh-my-posh
} else {
    Install-Module oh-my-posh -Scope CurrentUser
    Import-Module oh-my-posh
}

# Chocolatey profile
if (Test-Path("$env:ChocolateyInstall\helpers\chocolateyProfile.psm1")) {
  Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
}

##################################################
# Functions & Aliases
##################################################

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

##################################################
# Settings
##################################################

# Set Prompt Theme
Set-Theme paradox

# Start SshAgent if not already
# Need this if you are using github as your remote git repository
if (! (ps | ? { $_.Name -eq 'ssh-agent'})) {
    Start-SshAgent
}
