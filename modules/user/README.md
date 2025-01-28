# User Modules

This directory holds modules which can be used to configure user-specific settings, generally via home-manager.
Occasionally, a user-level setting will also make a change to the system configuration, but this is rare.

All options and configurations in this directory are namespaced under `profiles.<username>`, where `<username>` is the name of the user the profile is for.
This is done to enable multiple users to have independent home configurations without duplicating modules.

Nix submodules can be used to leave a space for the username in the option path.
You will see the following pattern in many modules:

```nix
{
  options.profiles = with lib.types; lib.mkOption {
    type = attrsOf (submodule {
      options = {
        my-option = mkOption {
            type = bool;
            default = false;
        };
      };
    });
  };
}
```

This declares the option `profiles.<username>.my-option`, which can be configured independently per user.
These options are merged automatically with options from other user modules.

Correspondingly, configuration definitions generally look something like this:

```nix
{
  config.home-manager.users = lib.mapAttrs (username: profile: lib.mkIf profile.my-option.enable {
    # Insert user configuration here which is enabled by `my-option`
  }) config.profiles;
}
```

This will apply the user configuration to each user for whom `my-option` is enabled, and will do nothing for users who have it disabled.
