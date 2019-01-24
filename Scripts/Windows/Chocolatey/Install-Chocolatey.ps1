#Requires -RunAsAdministrator

# Install or upgrade Chocolatey
if ( !(Test-Path C:\ProgramData\chocolatey\bin\choco.exe) ) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

C:\ProgramData\chocolatey\bin\choco.exe upgrade -y chocolatey
