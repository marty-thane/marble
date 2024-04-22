#!/bin/bash

data="./files/"

install_dotfiles() {
	read -p 'GitHub URL: https://github.com/' gh_path
	git clone "https://github.com/$gh_path" dotfiles/
	mkdir -pv $HOME/.config/
	mv -iv dotfiles/* $HOME/.config/
	mv -iv dotfiles/.* $HOME/.config/
	rmdir -v dotfiles/
}

install_i3() {
	xbps-install -Sy $(cat $data/progs)
	mkdir -pv $HOME/.local/src/
	git clone https://github.com/marty-thane/sent.git $HOME/.local/src/sent/
	make -C $HOME/.local/src/sent/ install clean
	git clone https://github.com/marty-thane/dmenu.git $HOME/.local/src/dmenu/
	make -C $HOME/.local/src/dmenu/ install clean
}

grub_disable_timeout() {
	sed -i -E 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
}

setup_networkmanager() {
	rm -v /var/service/dhcpcd
	xbps-install -Sy NetworkManager polkit
	ln -s /etc/sv/NetworkManager /var/service
}

enable_dbus() {
	ln -s /etc/sv/dbus /var/service
}

disable_ssh() {
	rm -v /var/service/sshd
}

disable_root() {
	passwd -l root
}

numlock_at_boot() {
	mkdir -pv "/etc/sv/numlock"
	cp -v "$data/numlock" "/etc/sv/numlock/run"
	chmod +x /etc/sv/numlock/run
	ln -sv /etc/sv/numlock /var/service/
}

setup_locate() {
	xbps-install -Sy plocate
	updatedb -v
}

create_user_dirs() {
	xdg-user-dirs-update --force
}

setup_gpg() {
	mkdir -pv "$HOME/.local/share/gnupg"
	chmod 700 "$HOME/.local/share/gnupg"
	gpg --full-gen-key
	chmod 600 "$HOME/.local/share/gnupg/*"
}

bash_xdg() {
	mkdir -pv "/etc/profile.d/"
	mkdir -pv "/etc/bash/bashrc.d/"
	cp -v "$data/profile_xdg.sh" "/etc/profile.d/"
	cp -v "$data/bashrc_xdg.sh" "/etc/bash/bashrc.d/"
}

setup_doas() {
	xbps-install -Sy opendoas
	cp -v "$data/doas.conf" "/etc/"
}

install_addons() {
	firefox $(cat $data/addons)
	# install custom user.js
	for dir in $HOME/.mozilla/firefox/*; do
		[ -d "$dir" ] && wget -nv -O "$dir/user.js" \
			https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
	done
}
#!/bin/bash

data="./files/"

install_dotfiles() {
	read -p 'GitHub URL: https://github.com/' gh_path
	git clone "https://github.com/$gh_path" dotfiles/
	mkdir -pv $HOME/.config/
	mv -iv dotfiles/* $HOME/.config/
	mv -iv dotfiles/.* $HOME/.config/
	rmdir -v dotfiles/
}

install_i3() {
	xbps-install -Sy $(cat $data/progs)
	mkdir -pv $HOME/.local/src/
	git clone https://github.com/marty-thane/sent.git $HOME/.local/src/sent/
	make -C $HOME/.local/src/sent/ install clean
	git clone https://github.com/marty-thane/dmenu.git $HOME/.local/src/dmenu/
	make -C $HOME/.local/src/dmenu/ install clean
}

grub_disable_timeout() {
	sed -i -E 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
}

setup_networkmanager() {
	rm -v /var/service/dhcpcd
	xbps-install -Sy NetworkManager polkit
	ln -s /etc/sv/NetworkManager /var/service
}

enable_dbus() {
	ln -s /etc/sv/dbus /var/service
}

disable_ssh() {
	rm -v /var/service/sshd
}

disable_root() {
	passwd -l root
}

numlock_at_boot() {
	mkdir -pv "/etc/sv/numlock"
	cp -v "$data/numlock" "/etc/sv/numlock/run"
	chmod +x /etc/sv/numlock/run
	ln -sv /etc/sv/numlock /var/service/
}

setup_locate() {
	xbps-install -Sy plocate
	updatedb -v
}

create_user_dirs() {
	xdg-user-dirs-update --force
}

setup_gpg() {
	mkdir -pv "$HOME/.local/share/gnupg"
	chmod 700 "$HOME/.local/share/gnupg"
	gpg --full-gen-key
	chmod 600 "$HOME/.local/share/gnupg/*"
}

bash_xdg() {
	mkdir -pv "/etc/profile.d/"
	mkdir -pv "/etc/bash/bashrc.d/"
	cp -v "$data/profile_xdg.sh" "/etc/profile.d/"
	cp -v "$data/bashrc_xdg.sh" "/etc/bash/bashrc.d/"
}

setup_doas() {
	xbps-install -Sy opendoas
	cp -v "$data/doas.conf" "/etc/"
}

install_addons() {
	firefox $(cat $data/addons)
	# install custom user.js
	for dir in $HOME/.mozilla/firefox/*; do
		[ -d "$dir" ] && wget -nv -O "$dir/user.js" \
			https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
	done
}

declare -A root_options=(
    ["Disable GRUB Timeout"]="grub_disable_timeout"
    ["Disable Root Account"]="disable_root"
    ["Disable SSH"]="disable_ssh"
    ["Enable DBus"]="enable_dbus"
    ["Enable NumLock At Boot"]="numlock_at_boot"
    ["Install i3"]="install_i3"
    ["Make Bash XDG Compliant"]="bash_xdg"
    ["Setup Doas"]="setup_doas"
    ["Setup Locate"]="setup_locate"
    ["Setup NetworkManager"]="setup_networkmanager"
)

declare -A user_options=(
    ["Create User Directories"]="create_user_dirs"
    ["Install Dotfiles"]="install_dotfiles"
    ["Install Firefox Addons"]="install_addons"
    ["Setup GPG"]="setup_gpg"
)

# determine if running as root or normal user
if [ "$(id -u)" -eq 0 ]; then
	options=("${!root_options[@]}")
	role="root"
else
	options=("${!user_options[@]}")
	role="a normal user"
fi

while true; do
	echo "You are running Marble as ${role}. The following options are available:"

	PS3="Select: "
	select opt in "${options[@]}"; do
		if [ -n "$opt" ]; then
			if [ "$(id -u)" -eq 0 ]; then
				command="${root_options[$opt]}"
			else
				command="${user_options[$opt]}"
			fi
			eval "$command"
			read -p "Press Enter to continue."
		else
			echo "Invalid option. Try again."
		fi
		break
	done
	echo ""
done
