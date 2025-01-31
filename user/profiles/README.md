# User Profiles

This directory contains user profiles which can be applied to a system configuration.
Importing a module in this directory in a system configuration will automatically add that user to the system with all of their preferences and configurations.

A profile is simply a set of definitions for the convenience options declared in the `modules/user` directory.
These options modify the configuration *indirectly*:
consult the specific module where the option is declared to see what it actually does.

The option names correspond to the path where they are defined inside the `modules/user` directory.
For example, `browser.firefox.enable = true;` is a definition for the option `browser.firefox.enable`, declared in `modules/user/browser/firefox.nix`.
Consult that file to see what the option actually does.
