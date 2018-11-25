# Misc. Scripts

## Bootfile Support Scripts
- nix-setup.sh
  - Install nix package manager
  - Give option to install my common cli/tui applications
- symc.sh
  - Takes a path argument ($1)
  - searches for files/folder with a '.symc' extensions and links them to user config directory (~/.config/*)
  - '.symc' extension is stripped
- symh.sh
  - Takes a path argument ($1)
  - searches for files/folder with a '.symh' extensions and links them to user home directory
  - '.symh' extension is stripped and '.' is prepended to file/folder name
  
