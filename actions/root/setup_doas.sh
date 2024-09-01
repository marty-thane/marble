# Setup doas
pkg_install opendoas
cp -v "$STATIC_DIR/doas.conf" '/etc/'
echo 'ignorepkg=sudo' > /etc/xbps.d/nosudo.conf
pkg_remove sudo
