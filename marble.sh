#!/bin/bash

data="./files"
title="Marble"

root_actions=()
nonroot_actions=()

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

root_actions+=("setup_doas" "Setup doas")
setup_doas() {
	pkg_install opendoas
	cp -v "$data/doas.conf" '/etc/'
	echo 'ignorepkg=sudo' > /etc/xbps.d/nosudo.conf
	pkg_remove sudo
}

root_actions+=("grub_disable_timeout" "Disable GRUB timeout")
grub_disable_timeout() {
	if grep -q "^GRUB_TIMEOUT=" /etc/default/grub; then
		sed -i -E 's/GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/' /etc/default/grub
	else
		echo "GRUB_TIMEOUT=0" >> /etc/default/grub
	fi
	grub-mkconfig -o /boot/grub/grub.cfg
}

root_actions+=("setup_networkmanager" "Setup NetworkManager")
setup_networkmanager() {
	service_disable dhcpcd
	service_disable wpa_supplicant
	pkg_install NetworkManager polkit
	service_enable NetworkManager
}

root_actions+=("enable_dbus" "Enable DBus")
enable_dbus() {
	service_enable dbus
}

root_actions+=("disable_ssh" "Disable SSH")
disable_ssh() {
	service_disable sshd
}

root_actions+=("numlock_at_boot" "Enable NumLock at boot")
numlock_at_boot() {
	mkdir -pv "/etc/sv/numlock"
	cp -v "$data/numlock" "/etc/sv/numlock/run"
	chmod +x /etc/sv/numlock/run
	service_enable numlock
}

root_actions+=("disable_root" "Disable root login")
disable_root() {
	passwd -l root
}

root_actions+=("setup_locate" "Setup locate")
setup_locate() {
	pkg_install plocate
	updatedb -v
}

root_actions+=("bash_xdg" "Make bash XDG compliant")
bash_xdg() {
	mkdir -pv "/etc/profile.d/"
	cp -v "$data/profile_xdg.sh" "/etc/profile.d/"
	mkdir -pv "/etc/bash/bashrc.d/"
	cp -v "$data/bashrc_xdg.sh" "/etc/bash/bashrc.d/"
}

root_actions+=("install_i3" "Install i3")
install_i3() {
	pkg_install $(cat $data/progs)
	mkdir -pv $HOME/.local/src/
	git clone https://github.com/marty-thane/sent.git $HOME/.local/src/sent/
	make -C $HOME/.local/src/sent/ install clean
	git clone https://github.com/marty-thane/dmenu.git $HOME/.local/src/dmenu/
	make -C $HOME/.local/src/dmenu/ install clean
}

nonroot_actions+=("create_user_dirs" "Create user directories")
create_user_dirs() {
	xdg-user-dirs-update --force
}

nonroot_actions+=("install_dotfiles" "Install dotfiles")
install_dotfiles() {
	read -p 'GitHub URL: https://github.com/' gh_path
	git clone "https://github.com/$gh_path" $HOME/.config/
}

nonroot_actions+=("setup_gpg" "Setup GnuPG")
setup_gpg() {
	mkdir -pv "$HOME/.local/share/gnupg"
	chmod 700 "$HOME/.local/share/gnupg"
	gpg --gen-key
}

nonroot_actions+=("install_addons" "Install Firefox addons")
install_addons() {
	firefox $(cat $data/addons)
	# install custom user.js
	for dir in $HOME/.mozilla/firefox/*; do
		[ -d "$dir" ] && wget -nv -O "$dir/user.js" \
			https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
	done
}

# Determine privelege level, set actions accordingly
if [ $(id -u) -eq 0 ]; then
	role="root"
	actions=("${root_actions[@]}")
else
	role="non-root"
	actions=("${nonroot_actions[@]}")
fi

# Determine which TUI program to use
if type dialog > /dev/null; then
	tui="dialog"
else
	tui="whiptail"
fi

# Welcome screen
$tui --title "Notice" --ok-button "Proceed" \
	--msgbox "Welcome to Marble! An automated ricing solution. Please make sure your system is up to date before proceeding." \
	0 0

# Main loop
while true; do

	# Get user selection
	choice=$($tui --title "Actions" --ok-button "Select" --cancel-button "Exit" --notags \
		--menu "You are running Marble as ${role}. The following options are available:" \
		0 0 0 "${actions[@]}" 3>&1 1>&2 2>&3)
	code=$?

	# Clear the screen
	clear

	# Exit if the user wishes to
	if [ $code -ne 0 ]; then
		break
	fi

	# Carry out chosen action
	eval "$choice"
	read -n 1 -s -r -p "Press any key to continue."

done
