# Install i3
pkg_install $(cat $STATIC_DIR/progs)
mkdir -pv $HOME/.local/src/
git clone https://github.com/marty-thane/sent $HOME/.local/src/sent/
make -C $HOME/.local/src/sent/ install clean
git clone https://github.com/plattfot/pinentry-rofi $HOME/.local/src/pinentry-rofi/
cd $HOME/.local/src/pinentry-rofi/ && autoreconf -vif && ./configure && make check && make install
