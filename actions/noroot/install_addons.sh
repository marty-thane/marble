# Install Firefox addons
firefox $(cat $STATIC_DIR/addons)
# install custom user.js
for dir in $HOME/.mozilla/firefox/*; do
	[ -d "$dir" ] && wget -nv -O "$dir/user.js" \
	https://raw.githubusercontent.com/arkenfox/user.js/master/user.js
done
