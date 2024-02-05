# Marble

## Motivation

Whether you're a distro hopper or run Linux on multiple devices, sometimes you
find yourself doing repetitive tasks to ensure consistency across your systems.
Marble is a ricing toolkit in the form of a shell script that addresses this
inconvenience. It simplifies and automates numerous tedious tweaks you
typically perform on your system.

## Features

### Root Access:

- **GRUB Timeout**: Speed up system boot times by disabling the GRUB timeout.
- **SSH Disabling**: Easily remove the SSH daemon service to disable SSH
  access.
- **Root Account Disabling**: Disallow logging in as root for security reasons
  (use doas instead).
- **Package Updates**: Keep your system up-to-date by utilizing the xbps
  package manager for updates.
- **Fast File Searching**: Set up plocate for efficient file searching
  capabilities.
- **Bash XDG Compliance**: Ensure Bash complies with XDG standards using
  provided scripts.
- **Doas Setup**: Install and configure opendoas for streamlined management of
  elevated privileges.
- **Root Shell Change**: Change the root user's shell to /bin/bash
  effortlessly.

### Normal User Access:

- **Dotfiles Installation**: Simplify customization by easily installing
  dotfiles from a GitHub repository.
- **GnuPG Setup**: Streamline GnuPG setup by creating necessary directories and
  generating a new GPG key.
- **User Directories Creation**: Ensure the creation of default user
  directories using xdg-user-dirs.

## Requirements

- Void Linux (preferably with the XFCE desktop environment)
- Shell interpreter, preferably bash

## Usage

1. Clone the repository.
2. Navigate to the directory.
3. Run `marble.sh` either with root privileges or as a normal user.

## To-Do

- **Swap CapsLock and Escape**: Make using Vim more comfortable with this
  setting.
- **NumLock at boot**: Eliminate the need to manually enable NumLock at every
  system boot.
- **Install programs (i3)**: Install an alternative DE alongside XFCE for a
  more minimal workflow option.
- **Install Suckless stuff (sent, dmenu)**: Include patched versions of dmenu
  and sent, potentially as part of the i3 environment.
- **Auto-Ricing**: Integrate all features into a single option for easy
  customization and setup of a vanilla system.
