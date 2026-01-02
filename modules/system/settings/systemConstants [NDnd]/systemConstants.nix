{
  inputs,
  ...
}:
{
  # System-wide constants accessible via config.systemConstants
  # These replace the old systemIntegration options pattern

  flake.modules.generic.systemConstants =
    { lib, ... }:
    {
      options.systemConstants = lib.mkOption {
        type = lib.types.attrsOf lib.types.unspecified;
        default = { };
      };

      config.systemConstants = {
        # Default user information - can be overridden in user features
        adminEmail = "michaelowendyer@gmail.com";
      };
    };
}
