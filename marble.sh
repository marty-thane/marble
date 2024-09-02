#!/bin/bash

MARBLE="$(basename $0)"

STATIC_DIR="./static"
ACTIONS_DIR="./actions"

# Helper functions (might make porting to other distros easier)
pkg_install() {
       xbps-install -y $@
}
pkg_remove() {
       xbps-remove -y $@
}
service_enable() {
       ln -s /etc/sv/"$1" /var/service
}
service_disable() {
       rm /var/service/"$1"
}

# Source action, exit if any command fails
execute_action() {
	local -
	set -e
	source "$1"
}

# Determine privelege level
if [ $(id -u) -eq 0 ]; then
	ROLE="root"
else
	ROLE="noroot"
fi

for action in $ACTIONS_DIR/$ROLE/*; do
	description="$(head -n 1 "$action" | cut -c3-)"
	ACTIONS+=("$action" "$description")
done

# Welcome screen
whiptail --title "$MARBLE" --ok-button "Proceed" \
	--msgbox "Welcome to Marble! An automated ricing solution. Please make sure your system is up to date before proceeding." \
	0 0

# Main loop
while true; do

	# Get user selection
	choice=$(whiptail --title "$MARBLE" --ok-button "Select" --cancel-button "Exit" --notags \
		--menu "You are running Marble as ${ROLE}. The following options are available:" \
		0 0 0 "${ACTIONS[@]}" 3>&1 1>&2 2>&3)
	code=$?

	# Exit if the user wishes to
	if [ $code -ne 0 ]; then
		break
	fi

	# Carry out chosen action
	execute_action "$choice"
	read -n 1 -s -r -p "Press any key to continue."
	echo

done
