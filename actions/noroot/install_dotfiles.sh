# Install dotfiles
read -p 'GitHub URL: https://github.com/' gh_path
git clone "https://github.com/$gh_path" $HOME/.config/
