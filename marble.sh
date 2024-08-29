#!/bin/bash

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

data="./files/"
root_options=()
nonroot_options=()

root_options+=("setup_doas")
setup_doas() {
	pkg_install opendoas
	cp -v "$data/doas.conf" '/etc/'
	echo 'ignorepkg=sudo' > /etc/xbps.d/nosudo.conf
	pkg_remove sudo
}

root_options+=("grub_disable_timeout")
grub_disable_timeout() {
	if grep -q "^GRUB_TIMEOUT=" /etc/default/grub; then
		sed -i -E 's/GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/' /etc/default/grub
	else
		echo "GRUB_TIMEOUT=0" >> /etc/default/grub
	fi
	grub-mkconfig -o /boot/grub/grub.cfg
}

root_options+=("setup_networkmanager")
setup_networkmanager() {
	service_disable dhcpcd
	service_disable wpa_supplicant
	pkg_install NetworkManager polkit
	service_enable NetworkManager
}

root_options+=("enable_dbus")
enable_dbus() {
	service_enable dbus
}

root_options+=("disable_ssh")
disable_ssh() {
	service_disable sshd
}

root_options+=("numlock_at_boot")
numlock_at_boot() {
	mkdir -pv "/etc/sv/numlock"
	cp -v "$data/numlock" "/etc/sv/numlock/run"
	chmod +x /etc/sv/numlock/run
	service_enable numlock
}

root_options+=("disable_root")
disable_root() {
	passwd -l root
}

root_options+=("setup_locate")
setup_locate() {
	pkg_install plocate
	updatedb -v
}

root_options+=("bash_xdg")
bash_xdg() {
	mkdir -pv "/etc/profile.d/"
	cp -v "$data/profile_xdg.sh" "/etc/profile.d/"
	mkdir -pv "/etc/bash/bashrc.d/"
	cp -v "$data/bashrc_xdg.sh" "/etc/bash/bashrc.d/"
}

root_options+=("install_i3")
install_i3() {
	pkg_install $(cat $data/progs)
	mkdir -pv $HOME/.local/src/
	git clone https://github.com/marty-thane/sent.git $HOME/.local/src/sent/
	make -C $HOME/.local/src/sent/ install clean
	git clone https://github.com/marty-thane/dmenu.git $HOME/.local/src/dmenu/
	make -C $HOME/.local/src/dmenu/ install clean
}

nonroot_options+=("create_user_dirs")
create_user_dirs() {
	xdg-user-dirs-update --force
}

nonroot_options+=("install_dotfiles")
install_dotfiles() {
	read -p 'GitHub URL: https://github.com/' gh_path
	git clone "https://github.com/$gh_path" $HOME/.config/
}

nonroot_options+=("setup_gpg")
setup_gpg() {
	mkdir -pv "$HOME/.local/share/gnupg"
	chmod 700 "$HOME/.local/share/gnupg"
	gpg --gen-key
}

nonroot_options+=("install_addons")
install_addons() {
	firefox $(cat $data/addons)
	# install custom user.js
	for dir in $HOME/.mozilla/firefox/*; do
		[ -d "$dir" ] && wget -nv -O "$dir/user.js" \
			https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
	done
}

if [ $(id -u) -eq 0 ]; then
	role="root"
	options=("${root_options[@]}")
else
	role="non-root"
	options=("${nonroot_options[@]}")
fi

while true; do
	clear
	echo "you are running marble as ${role}. the following options are available:"
	PS3="your selection: "
	select opt in "${options[@]//_/ }"; do
		if [ -n "$opt" ]; then
			eval "${opt// /_}"
			read -n 1 -s -r -p "press any key to continue."
		else
			read -n 1 -s -r -p "invalid option. try again."
		fi
		break
	done
done
