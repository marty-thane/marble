# Marble

## Description

Marble is a bash script for customizing a Void Linux system,
with various preferences and setups to spare the user of repetetive
configuration tasks.

## Usage

1. Clone the repository like this: `git clone
   https://github.com/marty-thane/marble.git`
2. Go to the created directory: `cd marble`
4. Run Marble either with or without root privileges: `[sudo] ./marble.sh`

## Features

### Root User

- **Disable Grub Timeout:** Disables the timeout in the GRUB bootloader, making
  the system boot immediately without waiting for user input.
- **Disable Root Account:** Locks the root account, preventing anyone from
  logging in as root directly.
- **Disable SSH:** Stops and disables the SSH service, preventing remote login
  via SSH.
- **Enable NumLock At Boot:** Configures the system to enable NumLock
  automatically at boot.
- **Make Bash XDG Compliant:** Configures Bash to follow the XDG Base Directory
  Specification, ensuring consistency in storing user-specific configuration
  files.
- **Install i3 WM:** Installs the i3 window manager, providing a lightweight
  and efficient tiling window manager alternative to XFCE.
- **Setup Doas:** Installs and configures `doas`, a lightweight alternative to
  sudo for executing commands with superuser privileges.
- **Setup Locate:** Installs the `plocate` package and updates the locate
  database, allowing users to quickly search for files on the system.

### Non-Root User

- **Create User Directories:** Creates standard user directories (e.g.,
  Documents, Downloads, Music) using the xdg-user-dirs-update utility.
- **Install Dotfiles:** Clones dotfiles from a specified GitHub repository and
  installs them in the user's `~/.config` directory.
- **Install Firefox Addons:** Installs Firefox addons listed in a specified
  file.
- **Setup GPG:** Sets up the GnuPG (GPG) keychain for encryption and
  authentication purposes.

## Disclaimer

Marble is designed for Void Linux XFCE version and may not be compatible with
other distributions or desktop environments. Use at your own risk. Ensure you
understand the actions performed by the script before executing it.

## To-Do

- **Auto-Ricing:** Integrate all features into a single option for easy
  customization and setup of a vanilla system.
