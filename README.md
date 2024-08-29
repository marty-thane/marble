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


## Disclaimer

Marble is designed for Void Linux/i3 systems and may not be compatible with
other distributions or desktop environments. Use at your own risk. Ensure you
understand the actions performed by the script before executing it.

## To-Do

- **Auto mode:** Integrate all features into a single option for easy
  customization and setup of a vanilla system.
- **Safety measures:** Create logic for handling exceptions and unforeseen
  scenarios (file not found etc.).
- **Logging:** Many actions the script provides lack proper logging, leaving
  the user guessing about what is going on. It should be unified as much as
  possible.
- **Multiple parts:** Separate frontend/backend parts of the script into
  separate files, making them easier to navigate.
- **Order:** Actions should follow a logical order in case the user decides to
  go through all of them. May not be necessary once automatic mode is
  implemented.
