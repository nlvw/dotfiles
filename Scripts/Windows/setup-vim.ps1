#Requires -RunAsAdministrator

# Ensure Chocolatey Is Installed
if ( !(Test-Path C:\ProgramData\chocolatey\bin\choco.exe) ) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install Vim
C:\ProgramData\chocolatey\bin\choco.exe upgrade -y vim

# Cleanup Possible Conflicting Files/Folders
Get-Item -Path $env:USERPROFILE\.vim -ErrorAction Ignore | Where { !($_.Attributes -match "ReparsePoint") } | Remove-Item -Recurse -Force | Out-Null
Get-Item -Path $env:USERPROFILE\vimfiles -ErrorAction Ignore | Where { !($_.Attributes -match "ReparsePoint") } | Remove-Item -Recurse -Force | Out-Null
Get-Item -Path $env:USERPROFILE\_viminfo -ErrorAction Ignore | Remove-Item -Force | Out-Null

# Create Symlinks
$RepoDir = Split-Path -Path $(Split-Path -Path $PSScriptRoot -Parent) -Parent
$VimFiles = "$env:USERPROFILE\.vim"

New-Item -ItemType SymbolicLink -Path $VimFiles -Value $RepoDir\CLI\vim.symc -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\_vimrc" -Value "$VimFiles\vimrc.vim" -Force

# Download Plugins
vim +PlugInstall +qall
