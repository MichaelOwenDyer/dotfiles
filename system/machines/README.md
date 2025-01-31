# Machines

This directory contains machine-specific NixOS configurations, and one `default.nix` file containing common configuration for all machines.

These configurations bulk-import the modules in `/system/modules` and `/user/modules` so that their options are declared and available to define.
Then, adding a user to a machine is as simple as importing that user's profile.
