# Setup GnuPG
mkdir -pv "$HOME/.local/share/gnupg"
chmod 700 "$HOME/.local/share/gnupg"
echo 'pinentry-program /usr/local/bin/pinentry-rofi' > "$HOME/.local/share/gnupg/gpg-agent.conf"
gpg-connect-agent reloadagent /bye
gpg --gen-key
