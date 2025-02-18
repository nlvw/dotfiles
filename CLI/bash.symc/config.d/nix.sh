#!/usr/bin/env bash

# if nix env exits source it
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
	source "$HOME/.nix-profile/etc/profile.d/nix.sh"
	export LOCALE_ARCHIVE_2_11="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
	export LOCALE_ARCHIVE_2_27="$(nix-build --no-out-link "<nixpkgs>" -A glibcLocales)/lib/locale/locale-archive"
	export LOCALE_ARCHIVE="/usr/bin/locale"
fi
