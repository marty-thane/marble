# Setup doas
pkg_install opendoas
cp -v "$STATIC_DIR/doas.conf" '/etc/'
chown -c root:root /etc/doas.conf
chmod -c 0400 /etc/doas.conf
echo 'ignorepkg=sudo' > /etc/xbps.d/nosudo.conf
pkg_remove sudo
