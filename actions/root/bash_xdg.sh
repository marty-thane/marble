# Make bash XDG compliant
mkdir -pv "/etc/profile.d/"
cp -v "$STATIC_DIR/profile_xdg.sh" "/etc/profile.d/"
mkdir -pv "/etc/bash/bashrc.d/"
cp -v "$STATIC_DIR/bashrc_xdg.sh" "/etc/bash/bashrc.d/"
