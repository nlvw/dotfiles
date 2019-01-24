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
