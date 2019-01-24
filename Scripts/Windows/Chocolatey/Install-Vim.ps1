#Requires -RunAsAdministrator

# Ensure Chocolatey Is Installed
if ( !(Test-Path C:\ProgramData\chocolatey\bin\choco.exe) ) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Ensure Cache Location
$cache = "C:\ProgramData\chocolatey\cache"
$getCache = & "C:\ProgramData\chocolatey\bin\choco.exe" config -r get cachelocation
if ( $cache.CompareTo($getCache) -ne 0) {
    & "C:\ProgramData\chocolatey\bin\choco.exe" config -r set cachelocation  $cache
}

# Install Variables
$packages = "neovim"

$setupexe = "C:\ProgramData\chocolatey\bin\choco.exe"
$setupargs = "upgrade -y $packages"

#Install
$proc = Start-Process -FilePath $setupexe -ArgumentList $setupargs -NoNewWindow -Wait -PassThru
if($proc.ExitCode -ne 0) {Exit $proc.ExitCode}

# Cleanup Cache
if (Test-Path $cache) {
	Remove-Item -Path "$cache\*" -Recurse -Force
}
if (Test-Path "$env:temp\chocolatey") {
	Remove-Item -Path "$env:temp\chocolatey" -Recurse -Force
}

# Cleanup Possible Conflicting Files/Folders
Get-Item -Path $env:USERPROFILE\.vim -ErrorAction Ignore | Where { !($_.Attributes -match "ReparsePoint") } | Remove-Item -Recurse -Force | Out-Null
Get-Item -Path $env:USERPROFILE\vimfiles -ErrorAction Ignore | Where { !($_.Attributes -match "ReparsePoint") } | Remove-Item -Recurse -Force | Out-Null
Get-Item -Path $env:USERPROFILE\_viminfo -ErrorAction Ignore | Remove-Item -Force | Out-Null

# Create Symlinks
$RepoDir = (Get-Item "$PSScriptRoot\..\..\..").FullName
$VimFiles = "$env:USERPROFILE\.vim"

New-Item -ItemType SymbolicLink -Path $VimFiles -Value $RepoDir\CLI\vim.symc -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\_vimrc" -Value "$VimFiles\vimrc.vim" -Force

# Download Plugins
vim +PlugInstall +qall
