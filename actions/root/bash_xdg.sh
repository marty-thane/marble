# Make bash XDG compliant
mkdir -pv "/etc/profile.d/"
cp -v "$STATIC_DIR/profile_xdg.sh" "/etc/profile.d/"
chmod -c 644 "/etc/profile.d/profile_xdg.sh"
mkdir -pv "/etc/bash/bashrc.d/"
cp -v "$STATIC_DIR/bashrc_xdg.sh" "/etc/bash/bashrc.d/"
chmod -c 644 "/etc/bash/bashrc.d/bashrc_xdg.sh"
