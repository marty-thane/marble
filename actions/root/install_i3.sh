# Install i3
pkg_install $(cat $STATIC_DIR/progs)
mkdir -pv $HOME/.local/src/
git clone https://github.com/marty-thane/sent.git $HOME/.local/src/sent/
make -C $HOME/.local/src/sent/ install clean
