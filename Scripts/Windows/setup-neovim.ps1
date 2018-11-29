#Requires -RunAsAdministrator

# Ensure Chocolatey Is Installed
if ( !(Test-Path C:\ProgramData\chocolatey\bin\choco.exe) ) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install Neoim
C:\ProgramData\chocolatey\bin\choco.exe upgrade -y neovim

# Create Config Directory
New-Item -Path "$env:LOCALAPPDATA\nvim" -ItemType Directory -Force | Out-Null

# Create Symlink to vimrc
$initvim = 
'" Regular Vims settings
set runtimepath^=$USERPROFILE\.vim
set packpath^=$USERPROFILE\.vim
source $USERPROFILE\.vim\vimrc.vim
'
$initvim | Out-File "$env:LOCALAPPDATA\nvim\init.vim" -Encoding utf8 -Force

# Download Plugins
nvim +PlugInstall +qall
