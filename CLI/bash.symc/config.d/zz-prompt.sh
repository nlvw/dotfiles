#!/usr/bin/env bash

# Enable TERM Color Profile
export TERM='xterm-256color'

# Reset Color
tput sgr0

# Solarized Dark colors, taken from http://git.io/solarized-colors.
_bold="\[$(tput bold)\]"
_reset="\[$(tput sgr0)\]"
_black="\[$(tput setaf 0)\]"
_blue="\[$(tput setaf 33)\]"
_cyan="\[$(tput setaf 37)\]"
_green="\[$(tput setaf 64)\]"
_orange="\[$(tput setaf 166)\]"
_purple="\[$(tput setaf 125)\]"
_red="\[$(tput setaf 124)\]"
_violet="\[$(tput setaf 61)\]"
_white="\[$(tput setaf 15)\]"
_yellow="\[$(tput setaf 136)\]"

# Highlight the user name when logged in as root.
if [ "${USER}" == "root" ]; then
hostStyle="${_orange}[\H]"
userStyle="${_red}"
prompt="${_white}#"
else
hostStyle="${_yellow}[\h]"
userStyle="${_green}"
prompt="${_white}\$"
fi

# Set the terminal title and prompt.
if [ -z "$APPTAINER_CONTAINER" ]; then
	PS1="${hostStyle}"
	PS1+="${userStyle}[\u]"
	PS1+="${_cyan}[\w]"
	PS1+="\n"
	PS1+="${prompt} ${_reset}"
	export PS1

	PS2="${_purple}> ${_reset}"
	export PS2
else
	# Container Override
	PS1='\[\e[38;5;214m\][Container]\[\e[38;5;28m\][\u]\[\e[38;5;32m\][\w]\n\[\e[0m\]\\$ '
	PS2='\[\e[38;5;165m\]> \[\e[0m\]'
fi

# Set Prompt Command
PROMPT_COMMAND='[ "$(type -t custom_prompt)" == "function" ] && custom_prompt'

