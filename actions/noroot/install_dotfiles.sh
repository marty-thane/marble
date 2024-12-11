# Install dotfiles
read -p 'GitHub URL: https://github.com/' ghpath
confdir="${XDG_CONFIG_HOME:-$HOME/.config}"
[ -d "$confdir" ] && rm -rvI "$confdir"
git clone "https://github.com/$ghpath" $confdir
