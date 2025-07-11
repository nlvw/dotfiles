#!/usr/bin/env bash

# Add to PATH if not in PATH
function pathadd() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		if [ "$2" == "prepend" ]; then
			PATH="$1${PATH:+":$PATH"}"
		else
			PATH="${PATH:+"$PATH:"}$1"
		fi
	fi
}

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_" || exit
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$*" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Use Git’s colored diff when available
if hash git &>/dev/null; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# `v` with no arguments opens the current directory in Vim, otherwise opens the
# given location
#function v() {
#	if [ $# -eq 0 ]; then
#		vim .;
#	else
#		vim "$@";
#	fi;
#}

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# colored man pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[01;33;03;40m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

tabname_ssh(){
	# Extract User and Host from SSH command
	local orig_cmd="$*"
	local ssh_info_cmd="${orig_cmd/ssh/$(which --skip-alias --skip-functions ssh) -G}"
	local ssh_info="$(eval "$ssh_info_cmd")"
	local hname="$(grep '^hostname' <<< "$ssh_info" | awk '{print $2}' | awk -F'.' '{print $1}')"
	local uname="$(grep '^user ' <<< "$ssh_info" | awk '{print $2}')"

	# Determine Desired Tab Name
	if [ "$uname" == "pkgmgr" ]; then
		local name="$uname"
	else
		local name="$hname"
	fi

	# Return Name
	echo "$name"
}

# Set tmux window title on ssh
tmux_ssh(){
	# Get Current tmux Window Name
	wid="$(tmux list-windows| awk -F : '/\(active\)$/{print $1}')"

	# Use current window to change back the setting. If not it will be applied to the active window
	trap 'tmux set-window-option -t "$wid" automatic-rename on 1>/dev/null' RETURN

	# Rename tmux Window
	tmux rename-window "$(tabname_ssh "$@")"

	# Call SSH
	command "$@"

}

# Set zellij window title on ssh
zellij_ssh(){
	# Rename Tab
	zellij action rename-tab "SSH:$(tabname_ssh "$@")"

	# Call SSH
	command "$@"

	# Restore Tab Name
	zellij action undo-rename-tab
}

# Intercept 'ssh' and handle multiplexer window title
ssh() {
	if [ -n "$TMUX" ]; then
		tmux_ssh ssh "$@"
	elif [ -n "$ZELLIJ_SESSION_NAME" ]; then
		zellij_ssh ssh "$@"
	else
		command ssh "$@"
	fi
}

ensure_keyctl_session() {
	if ! command -v keyctl &>/dev/null; then
		echo "'keyctl' is not in '$PATH'. Stopping!!" 1>&2
		return 1
	fi

	if ! keyctl list @s &>/dev/null; then
		keyctl new_session
	fi
}

# Lmod Setup
os_ver="$(grep -i '^VERSION_ID' /etc/os-release | awk -F'=' '{print $2}' | sed 's/"//g' | tr '[:upper:]' '[:lower:]')"
os_name="$(grep -i '^NAME' /etc/os-release | awk -F'=' '{print $2}' | sed 's/"//g' | sed 's/ /_/g' | tr '[:upper:]' '[:lower:]')"
sstack_stack_name="${os_name}-${os_ver}"
if [[ $(type -t module) == function ]] && [ -d "$HOME/sstack/$sstack_stack_name/modules" ]; then
        module use "$HOME/sstack/$sstack_stack_name/modules"
fi
unset os_ver
unset os_name
unset sstack_stack_name

# Intercept 'govc' and handle password
govc() {
	# Check for govc
	if ! command -v govc &>/dev/null; then
		echo "'govc' is not in ${PATH}. Stopping!!" 1>&2
		return 1
	fi

	# Handle URL
	if [ -z "$GOVC_URL" ]; then
		read -rp "VMware URL: " GOVC_URL
		export GOVC_URL
	fi

	# Handle User Name
	if [ -z "$GOVC_USERNAME" ]; then
		read -rp "VMware Username: " GOVC_USERNAME
		export GOVC_USERNAME
	fi

	# Handle Password
	if [ -z "$GOVC_PASSWORD" ]; then
		ensure_keyctl_session >/dev/null || return 2
		if keyctl search @s user "GOVC_PASSWORD" &>/dev/null; then
			keyid="$(keyctl search @s user "GOVC_PASSWORD")"
			GOVC_PASSWORD="$(keyctl print "$keyid")"
		else
			read -rsp "VMware Password ($GOVC_USERNAME): " GOVC_PASSWORD
			echo ""
			keyid="$(keyctl add user "GOVC_PASSWORD" "$GOVC_PASSWORD" @s)"
			keyctl timeout "$keyid" 1200
		fi
		export GOVC_PASSWORD
	fi

	command govc "$@" || unset GOVC_PASSWORD

	# Cleanup Password
	unset GOVC_PASSWORD
}

# Zellij Use Default Session
zellij() {
	if [ $# -eq 0 ]; then
		command zellij attach -c default
	else
		command zellij "$@"
	fi
}

# Prompt Function
custom_prompt() {
	# Update History File
	history -a

	# Update Zellij Tab Name
	if [ -n "$ZELLIJ" ] \
		&& [ -n "$ZELLIJ_SESSION_NAME" ] \
		&& [ -n "$ZELLIJ_PANE_ID" ] \
		&& [ -z "$APPTAINER_CONTAINER" ] \
		&& which --skip-alias --skip-functions zellij &>/dev/null
	then
		zellij action rename-tab "$(pwd | sed "s;$HOME;~;" | xargs basename)"
	fi
}

