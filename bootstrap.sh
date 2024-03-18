#!/bin/bash
# ----------------------------------
# Variables
# ----------------------------------
RED='\033[0;41;30m'
STD='\033[0;0;39m'
DFROOT="$(dirname "$(readlink -f "$0")")"

# ----------------------------------
# Functions
# ----------------------------------
pause(){
	echo ""
	read -p "Press [Enter] key to continue..." fackEnterKey
}

autolinker(){
	echo "Auto Symlinking .symc/.symh objects in $1"

	if [ -d "$1" ]; then
		# Create/Refresh dotfile symlinks (~/.config/*)
		mkdir ~/.config &>/dev/null || true
		for src in $(find -H "$1" -maxdepth 4 -name '*.symc' -not -path '*.git*'); do
			dst="$HOME/.config/$(basename "${src%.*}")"
			rm -rf "$dst" &>/dev/null || true
			ln -rsf "$src" "$dst"
		done

		# Create/Refresh dotfile symlinks (~/*)
		for src in $(find -H "$1" -maxdepth 4 -name '*.symh' -not -path '*.git*'); do
			dst="$HOME/.$(basename "${src%.*}")"
			rm -rf "$dst" &>/dev/null || true
			ln -rsf "$src" "$dst"
		done

		echo "Symlinks have been created!"
	else
		echo -e "${RED}${1} Not Found!!!${STD}"
	fi

	pause
}

binlinker() {
	mkdir -p "$HOME/.local/bin"
	for src in $(find -H "$1" -maxdepth 1 -type f); do
		dst="$HOME/.local/bin/$(basename "$src")"
		rm -rf "$dst" &>/dev/null || true
		ln -rsf "$src" "$dst"
	done
	echo "Symlinks have been created!"
	pause
}

gitinfo() {
	echo "Setting Default Git Author Name and Email!"
	if [ -d "$HOME/.config/git" ]; then
		touch "$HOME/.config/git/userinfo"

		read -erp 'What is your git author name?: ' git_authorname
		read -erp 'What is your git author email?: ' git_authoremail

		echo "[user]" > "$HOME/.config/git/userinfo"
		echo "name = ${git_authorname}" >> "$HOME/.config/git/userinfo"
		echo "email = ${git_authoremail}" >> "$HOME/.config/git/userinfo"

		echo "Git User Info Set!"
	else
		echo -e "${RED}Git User Info NOT Set! CLI Config Files Must Be Linked First!!${STD}"
	fi

	pause
}

sshinit() {
	if [ ! -f ~/.ssh/config ]; then
		mkdir ~/.ssh &>/dev/null || true
		touch ~/.ssh/config
		chmod -R 700 ~/.ssh
		echo "AddKeysToAgent yes" >> ~/.ssh/config

		echo "SSH Directory and Config File Have Been Initialized!"
	else
		echo -e "${RED}~/.ssh/config already exists! Skipping SSH initialization!!${STD}"
	fi

	pause
}

npminit(){
	mkdir -p "$HOME/.local/npm-packages"
	source "$HOME/.bashrc"
	npm -g install @antora/cli @antora/site-generator-default antora-lunr antora-site-generator-lunr asciidoctor bash-language-server
}

npmupdate(){
	source "$HOME/.bashrc"
	npm -g update
}

vimplug() {
	if [ -d "$HOME/.config/vim/" ]; then
		vim -u "$HOME/.config/vim/vimrc.vim" +PlugInstall +qall
		echo "Vim plugins have been installed/updated!"
	else
		echo -e "${RED}~/.config/vim directory not found! CLI Config Files Must Be Linked First!!${STD}"
	fi

	pause
}

doomsetup() {
	if [ -d "$HOME/.doom.d/" ]; then
		git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
		~/.emacs.d/bin/doom install
	else
		echo -e "${RED}~/.doom.d directory not found! CLI Config Files Must Be Linked First!!${STD}"
	fi
}

nixsetup() {
	if [ ! -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
		echo "Installing Nix Package Manager!"

		if grep -q Microsoft /proc/version; then
  			echo "Ubuntu on Windows"
			sudo mkdir /etc/nix;
			echo 'use-sqlite-wal = false' > /etc/nix/nix.conf
			echo 'sandbox = false' >> /etc/nix/nix.conf
		fi

		curl https://nixos.org/nix/install | sh
		source "$HOME/.nix-profile/etc/profile.d/nix.sh"

		echo "Installation Finished!!"
	fi

	pause
}

nixbasics() {
	nixsetup

	echo "Installing Basic Apps/Fonts Using Nix! This May Take Some Time!!"

	# Install Nix Packages
	nix-env -i vim neovim emacs ranger tmux git fzf ripgrep ripgrep-all fd pandoc roboto roboto-mono roboto-slab source-code-pro
	nix-env -iA nixpkgs.glibcLocales nixpkgs.shellcheck

	# Link Nix Fonts
	mkdir -p ~/.local/share/fonts
	ln -sf "$HOME/.nix-profile/share/fonts" ~/.local/share/fonts/nix_fonts

	echo "Installation Finished!"

	pause
}

nixupdate() {
	nixsetup

	echo "Updating Apps/Fonts Installed By Nix! This May Take Some Time!!"

	# Update Nix Environment
	nix-env -u

	echo "Updates Finished!"

	pause
}

# function to display menus
show_menus() {
	clear
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo " B O O T S T R A P - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Link/Relink BIN Files"
	echo "2. Link/Relink CLI Config Files"
	echo "3. Link/Relink GUI Config FIles"
	echo ""
	echo "4. Git Default Author/Email"
	echo "5. SSH Init (~/.ssh & ~/.ssh/config)"
	echo "6. Vim Plugins (Install/Update)"
	echo "7. Install Doom Emacs"
	echo ""
	echo "8. Nix Setup"
	echo "9. Nix Install Basic Apps/Fonts"
	echo "10. Nix Update Packages"
	echo ""
	echo "11. Exit"
}
# read input from the keyboard and take a action
read_options(){
	local choice
	read -p "Enter choice [ 1 - 11 ] " choice
	case $choice in
		1) binlinker "${DFROOT}/BIN" ;;
		2) autolinker "${DFROOT}/CLI" ;;
		3) autolinker "${DFROOT}/GUI" ;;
		4) gitinfo ;;
		5) sshinit ;;
		6) vimplug ;;
		7) doomsetup ;;
		8) nixsetup ;;
		9) nixbasics ;;
		10) nixupdate ;;
		11) exit 0 ;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
			esac
}

# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Main logic - infinite loop
# ------------------------------------
while true
do
	show_menus
	read_options
done
