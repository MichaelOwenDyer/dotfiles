# Modules

This directory holds Nix modules divided roughly into two categories: system-level and user-level.

Just importing a module in this directory will generally not have any effect on the configuration by itself.
This is because they are all declared with a set of accompanying options which must be defined in order for the module to have any effect.
Therefore, it is typical that this entire directory will be imported in bulk, and then the options will be set to enable and configure them as desired.

See the `README.md` files in each subdirectory for more information on the modules contained within.
