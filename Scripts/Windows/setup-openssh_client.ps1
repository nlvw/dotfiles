#Requires -RunAsAdministrator

# Create Symlink to config files
New-Item -Path $env:USERPROFILE\.ssh -ItemType Directory -Force

# Install OpenSSH Client
Get-WindowsCapability -Online | ? Name -like 'OpenSSH.Client*' | Add-WindowsCapability -Online

# Enable SSH Agent Service
Set-Service ssh-agent -StartupType Automatic
Start-Service ssh-agent
