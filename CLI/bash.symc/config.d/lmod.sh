#!/usr/bin/env bash

if [[ $(type -t module) == function ]] \
	&& [ -f "/usr/share/lmod/lmod/libexec/lmod" ] \
	&& which module | grep -iq lmod
then

	# Custom LMOD Settings
	export LMOD_PAGER="less"
	export LMOD_AUTO_SWAP="no"
	export LMOD_DISABLE_NAME_AUTOSWAP="yes"
	export LMOD_CASE_INDEPENDENT_SORTING="yes"
	export LMOD_COLORIZE="yes"
	export LMOD_EXACT_MATCH="no"
	export LMOD_MPATH_AVAIL="yes"
	export LMOD_PIN_VERSIONS="yes"
	export LMOD_PREPEND_BLOCK="normal"

	#
	# Setup SSTACK
	#

	# OS Info
	if grep -qi 'fedora' /etc/os-release ; then
		os_ver="$(grep -i '^VERSION_ID' /etc/os-release | awk -F'=' '{print $2}' | sed 's/"//g' | tr '[:upper:]' '[:lower:]' | awk -F'.' '{print $1}')"
	else
		os_ver="$(grep -i '^VERSION_ID' /etc/os-release | awk -F'=' '{print $2}' | sed 's/"//g' | tr '[:upper:]' '[:lower:]')"
	fi
	os_name="$(grep -i '^ID=' /etc/os-release | awk -F'=' '{print $2}' | sed 's/"//g' | sed 's/ /_/g' | tr '[:upper:]' '[:lower:]')"

	# SStack Data Root
	SSTACK_PATH="$HOME/sstack/${os_name}-${os_ver}"
	export SSTACK_PATH

	# Install SSTACK Function
	function sstack-update() {
		if [ ! -d "$SSTACK_PATH/stacks/sstack/home" ]; then
			curl -fsSL "https://gitlab.com/nmsu_hpc/sstack/-/raw/main/share/install_sstack_latest.sh" | bash -s -- "$SSTACK_PATH" "home"
		else
			curl -fsSL "https://gitlab.com/nmsu_hpc/sstack/-/raw/main/share/install_sstack_latest.sh" | bash -s -- "$SSTACK_PATH" "home" "update"
		fi
	}

	# Ensure SStack in Module Path
	if [[ ":$MODULEPATH:" != *":$SSTACK_PATH/modules:"* ]]; then
		module use "$SSTACK_PATH/modules"
	fi

	# Cleanup Vars
	unset os_ver
	unset os_name

fi

