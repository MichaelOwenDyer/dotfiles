# My NixOS Configuration

Welcome!

This is my NixOS configuration which I am continuously developing as I learn more about the Nix ecosystem. I am still a Nix noob but I do hope that by making this repository public and providing good documentation I can help out other people in the same boat as me.

## Organization

I have decided to organize the files in this repository roughly into two directories, `system` and `user`, representing the corresponding level of configuration.
Both of these directories have a subdirectory called `modules`.
This is where packages, services, and applications are configured in a reusable manner.

Every module is implemented in such a way that just importing it will not have any effect; the modules are inert unless explicitly enabled via their associated options.
This is advantageous because it means we can do a bulk import of all modules once, and then selectively enable and configure them as we desire.
I think this is a better approach than having to deal with adding or removing imports to enable or disable features.

The other subdirectories inside `user` and `system` (`profiles` and `machines`, respectively) contain usages of the aforementioned modules.
They represent individual instantiations of the configuration options for a specific purpose.

See the `README.md` files in each subdirectory for more information on the modules contained within.

See `flake.nix` for the entry point to the configuration.
