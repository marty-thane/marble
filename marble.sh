#!/bin/bash

data="./marble_files/"

install_dotfiles() {
	read -p "GitHub URL: https://github.com/" gh_path

	# Make sure git is installed
	if ! command -v git &> /dev/null; then
		echo "Error: 'git' is not installed. Please install it and run the script again."
		exit 1
	fi

	git clone "https://github.com/$gh_path.git" dotfiles/
	mv -iv dotfiles/* "$HOME/.config/"
	rm -rf dotfiles/
}

grub_disable_timeout() {
	sed -i -E 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
	grub-mkconfig -o /boot/grub/grub.cfg
}

disable_ssh() {
	rm /var/service/sshd
}

update_packages() {
	xbps-install -Suy xbps
	xbps-install -Suy
}

setup_gpg() {
	mkdir -p "$HOME/.local/share/gnupg"
	chmod 700 "$HOME/.local/share/gnupg"
	gpg --full-gen-key
	chmod 600 "$HOME/.local/share/gnupg/*"
}

create_user_dirs() {
	xdg-user-dirs --force
}

setup_locate() {
	xbps-install -Sy plocate
	updatedb
}

make_bash_xdg() {
	mkdir -p "/etc/profile.d/"
	mkdir -p "/etc/bash/bashrc.d/"
	cp "$data/profile_xdg.sh" "/etc/profile.d/"
	cp "$data/bashrc_xdg.sh" "/etc/bash/bashrc.d/"
}

setup_doas() {
	xbps-install -Sy opendoas
	cp "$data/doas.conf" "/etc/"
}

change_root_shell() {
	chsh -s /bin/bash root
}

declare -A root_options=(
	["Change Root Shell"]="change_root_shell"
	["Disable SSH"]="disable_ssh"
	["Grub Disable Timeout"]="grub_disable_timeout"
	["Make Bash XDG Compliant"]="make_bash_xdg"
	["Setup Doas"]="setup_doas"
	["Setup Locate"]="setup_locate"
	["Update Packages"]="update_packages"
)

declare -A user_options=(
	["Create User Directories"]="create_user_dirs"
	["Install Dotfiles"]="install_dotfiles"
	["Setup GPG"]="setup_gpg"
)

# Determine if running as root or normal user
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
