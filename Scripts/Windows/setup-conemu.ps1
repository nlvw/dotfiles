#Requires -RunAsAdministrator

# Ensure Chocolatey Is Installed
if ( !(Test-Path C:\ProgramData\chocolatey\bin\choco.exe) ) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Install Neoim
C:\ProgramData\chocolatey\bin\choco.exe upgrade -y conemu

# Load/Import Config
#Start-Process -FilePath "C:\Program Files\ConEmu\ConEmu64.exe" -ArgumentList "" -Wait
Write-Host "XML Config Will Need to Be loaded manually" -ForegroundColor Cyan
