#Requires -RunAsAdministrator

# Create Symlink to config files
New-Item -Path $env:USERPROFILE\.ssh -ItemType Directory -Force

# Install OpenSSH Client
Get-WindowsCapability -Online | ? Name -like 'OpenSSH.Client*' | Add-WindowsCapability -Online

# Enable SSH Agent Service
Set-Service ssh-agent -StartupType Manual

# Create SSH Folder and Settings
New-Item -Path "$env:USERPROFILE\.ssh" -ItemType Directory -Force | Out-Null
$config = "AddKeysToAgent yes"
$config | Out-File "$env:USERPROFILE\.ssh\config" -Encoding utf8 -Force