# Setup GnuPG
mkdir -pv "$HOME/.local/share/gnupg"
chmod 700 "$HOME/.local/share/gnupg"
gpg --gen-key
