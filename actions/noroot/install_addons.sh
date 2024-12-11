# Install Firefox addons
firefox $(cat $STATIC_DIR/addons)
ffdir="$HOME/.mozilla/firefox/"
ffprofile="$(cat "$ffdir/profiles.ini" | grep -m1 'Default' | cut -d'=' -f2)"
wget -nv -O "$ffdir/$ffprofile/user.js" \
	https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
