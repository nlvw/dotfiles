#!/usr/bin/env bash

# Stop if not an interactive bash shell
if [ -z "$PS1" ] || [ -z "$BASH_VERSION" ]; then
	return
fi

# Function that outputs the pretty hostname, or falls back to the local kernel short hostname
get_prompt_host() {
	local PRETTY_HOSTNAME kernel_host host
	if [ -r /etc/machine-info ]; then
		source /etc/machine-info 2>/dev/null
	fi
	if [ -r /proc/sys/kernel/hostname ]; then
		read -r kernel_host < /proc/sys/kernel/hostname
	else
		kernel_host="$(hostname -s)"
	fi
	host="${PRETTY_HOSTNAME:-$kernel_host}"
	printf "%s" "${host%%.*}"
}

# Export the function so subshells inherit it
export -f get_prompt_host

# Enable TERM Color Profile
if [ -z "$TERM" ] || [ "$TERM" = "xterm" ]; then
	export TERM='xterm-256color'
fi

# Base ANSI Palette (Automatically adapts to client Light/Dark terminal themes)
_bold="\[$(tput bold 2>/dev/null)\]"
_reset="\[$(tput sgr0 2>/dev/null)\]"
_black="\[$(tput setaf 0 2>/dev/null)\]"
_red="\[$(tput setaf 1 2>/dev/null)\]"
_green="\[$(tput setaf 2 2>/dev/null)\]"
_yellow="\[$(tput setaf 3 2>/dev/null)\]"
_blue="\[$(tput setaf 4 2>/dev/null)\]"
_purple="\[$(tput setaf 5 2>/dev/null)\]"
_cyan="\[$(tput setaf 6 2>/dev/null)\]"
_white="\[$(tput setaf 7 2>/dev/null)\]"

# Highlight the user name when logged in as root.
if [ "${EUID:-$(id -u)}" -eq 0 ]; then
	ps1_apptainer="${_yellow}[Container]${_blue}[\h]"
	ps1_host="${_blue}[\h]"
	ps1_user="${_bold}${_red}[\u]${_reset}"
	ps1_path="${_cyan}[\w]"
	ps1_prompt="${_purple}#"
else
	ps1_apptainer="${_yellow}[Container]${_blue}[\h]"
	ps1_host="${_blue}[\$(get_prompt_host)]"
	ps1_user="${_cyan}[\u]"
	ps1_path="${_green}[\w]"
	ps1_prompt="${_purple}\$"
fi

# Set input prompt
PS2="${_purple}> ${_reset}"
export PS2

# Set Apptainer PS1/PS2
APPTAINERENV_PS1="${ps1_apptainer}${ps1_user}${ps1_path}\n${ps1_prompt} ${_reset}"
APPTAINERENV_PS2="$PS2"
export APPTAINERENV_PS1
export APPTAINERENV_PS2

# Set the terminal title and prompt.
if [ -n "$APPTAINER_CONTAINER" ] || [ -n "$SINGULARITY_CONTAINER" ]; then
	PS1="$APPTAINERENV_PS1"
else
	PS1="${ps1_host}${ps1_user}${ps1_path}\n${ps1_prompt} ${_reset}"
fi
export PS1

# Set Prompt Command
PROMPT_COMMAND='[ "$(type -t custom_prompt)" == "function" ] && custom_prompt'

