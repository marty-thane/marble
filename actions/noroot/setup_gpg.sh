# Setup GnuPG
mkdir -pv "$HOME/.local/share/gnupg"
chmod -c 700 "$HOME/.local/share/gnupg"
echo 'pinentry-program /usr/bin/pinentry-gnome3' > "$HOME/.local/share/gnupg/gpg-agent.conf"
gpg-connect-agent reloadagent /bye
read -p "Path to .asc key (skip to generate new): " keyfile
if [ -z "$keyfile" ]; then
	gpg --gen-key
else
	if [ -f "$keyfile" ]; then
		gpg --import "$keyfile"
	fi
fi
