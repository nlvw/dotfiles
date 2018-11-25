# DotFiles For My Linux Preferences
The repository is split between settings for cli/tui and gui settings.  

## Setup Instructions

```bash
git clone https://github.com/Wolfereign/dotfiles.git
cd dotfiles
bash bootstrap.sh
```

## Nix
bootstrap.sh will give the option to install the Nix package manager.
If Nix is chosen to be installed the option to install some predefined applicaitons/fonts is given.

## Auto Symlink Determination

* "file.symh" -> "~/.file"
* "file.symc" -> "~/.config/file"

The bootstrap.sh script will search the repository for the above extenstions and automatically create symlinks as specified.
This works for both files and folders.

- CLI dotfiles are automatically linked
- GUI dotfiles are optionally linked (Yy/Nn prompt)
  - If "~/.config/i3" exists then linking is done automatically
