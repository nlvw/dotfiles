#!/bin/bash
# shellcheck disable=SC2044

# ----------------------------------
# Variables
# ----------------------------------
RED='\033[0;41;30m'
STD='\033[0;0;39m'
DFROOT="$(dirname "$(readlink -f "$0")")"

# ----------------------------------
# Functions
# ----------------------------------
pause() {
	echo ""
	read -rp "Press any key to continue... " -n1 -s
}

autolinker() {
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

		echo "[user]" >"$HOME/.config/git/userinfo"
		echo "name = ${git_authorname}" >>"$HOME/.config/git/userinfo"
		echo "email = ${git_authoremail}" >>"$HOME/.config/git/userinfo"

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
		echo "AddKeysToAgent yes" >>~/.ssh/config

		echo "SSH Directory and Config File Have Been Initialized!"
	else
		echo -e "${RED}~/.ssh/config already exists! Skipping SSH initialization!!${STD}"
	fi

	pause
}

ensure_pixi() {
	# Ensure Pixi Is Installed/Setup
	if ! which --skip-alias --skip-functions pixi &>/dev/null; then
		mkdir -p ~/.pixi/bin
		curl -fsSL https://pixi.sh/install.sh | PIXI_HOME="$HOME/.pixi" PIXI_NO_PATH_UPDATE="true" bash
	fi
	export PATH="$HOME/.pixi/bin:$PATH"
}

toolsetup() {
	ensure_pixi
	pixi global install --environment neovim --expose nvim nvim diffutils git lazygit tar curl gcc fzf ripgrep fd-find
	pixi global install zellij
	pixi global install tmux
	pixi global install htop
	pixi global install glances

	if [ "$1" == "plus-optional" ]; then
		pixi global install vim
		pixi global install emacs --expose emacs --expose emacsclient
		pixi global install helix
		pixi global install code-server
		pixi global install jq
		pixi global install xq
		pixi global install yq --expose yq
		pixi global install fzf
		pixi global install ripgrep
		pixi global install just
		pixi global install tldr
		pixi global install bash-language-server
		pixi global install yaml-language-server
		pixi global install shellcheck
		pixi global install --environment vale vale vale-ls
	fi

	pause
}

toolupdate() {
	ensure_pixi
	pixi self-update
	pixi global update
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
	echo ""
	echo "6. Install Required CLI Tools"
	echo "7. Install Optional Tools"
	echo "8. Update Installed Tools"
	echo ""
	echo "9. Exit"
}
# read input from the keyboard and take a action
read_options() {
	local choice
	read -rp "Enter choice [ 1 - 9 ] " choice
	case $choice in
	1) binlinker "${DFROOT}/BIN" ;;
	2) autolinker "${DFROOT}/CLI" ;;
	3) autolinker "${DFROOT}/GUI" ;;
	4) gitinfo ;;
	5) sshinit ;;
	6) toolsetup ;;
	7) toolsetup "plus-optional" ;;
	8) toolupdate ;;
	9) exit 0 ;;
	*) echo -e "${RED}Error...${STD}" && sleep 2 ;;
	esac
}

# ----------------------------------------------
# Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Main logic - infinite loop
# ------------------------------------
while true; do
	show_menus
	read_options
done
