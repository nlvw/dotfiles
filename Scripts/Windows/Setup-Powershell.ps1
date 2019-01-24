#Requires -RunAsAdministrator

# Execution Policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

# Install Chocolatey Package Manager
. "$PSScriptRoot\Chocolatey\Install-Chocolatey.ps1"

# Install Git
. "$PSScriptRoot\Chocolatey\Install-Git.ps1"

# Install ConEmu
. "$PSScriptRoot\Chocolatey\Install-ConEmu.ps1"

# Install OpenSSH Client
. "$PSScriptRoot\Chocolatey\Install-OpenSSH_Client.ps1"

# Install Powerline Fonts
Push-Location -Path $env:TEMP
git clone https://github.com/powerline/fonts.git powerline-fonts
. powerline-fonts\install.ps1
Remove-Item -Path .\powerline-fonts -Recurse -Force
Pop-Location

# Setup Nuget
Install-PackageProvider NuGet -Force

# Trust Powershell Gallery
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# Link Powershell Profile Files
#$RepoDir = (Get-Item "$PSScriptRoot\..\..").FullName
#New-Item -ItemType SymbolicLink -Path $profile.CurrentUserAllHosts -Value "$RepoDir\CLI\powershell\profile.ps1" -Force
#New-Item -ItemType SymbolicLink -Path "$(Split-Path -Path $profile.CurrentUserAllHosts -Parent)\Microsoft.PowerShellISE_profile.ps1" -Value "$RepoDir\CLI\powershell\profile-ise.ps1" -Force

# Source Profile
#. $profile.CurrentUserAllHosts