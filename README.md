Marble
======
Marble is a shell script for customizing a Void Linux system. Its main purpose
is to spare the user of boring configuration tasks after a fresh install.
Instead, it provides a fast TUI interface and a set of actions the user can
execute.

Usage
-----
To run Marble, follow these steps:

1. Clone this repository: `git clone https://github.com/marty-thane/marble`
2. Change to the newly created directory: `cd marble`
3. Run Marble either with or without root privileges: `[sudo] ./marble.sh`

**Note:** The privilege level will affect what actions are available to you. This
is due to the fact that some actions need to be carried out specifically by the
user, while others as root.

Disclaimer
----------
Marble is tailored specifically for Void Linux/i3 systems and may not be
compatible with other distributions or desktop environments. Use at your own
risk. Ensure you understand the actions performed by the script before
executing them.

To-Do
-----
- **Auto mode:** Integrate all features into a single option for easy
  customization and setup of a vanilla system.
- **Logging:** Many actions lack proper logging, leaving the user guessing
  about what is going on.
