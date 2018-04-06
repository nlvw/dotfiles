# DotFiles For My Linux Preferences

## Setup Instructions

```bash
cd ~
git clone https://github.com/Wolfereign/.dotfiles.git 
bash ~/.dotfiles/bootstrap.sh
```

## Auto Symlink Determination

* "file.symh" -> "~/.file"
* "file.symc" -> "~/.config/file"

The bootstrap.sh script will search the repository for the above extenstion and automatically create symlinks as specified.