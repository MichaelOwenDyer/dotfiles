{
  lib,
  ...
}:

{
  # Common modules should always be available
  imports = [
    ./common
  ];

  # Declare basic system configuration options
  options = with lib.types; {
    # TODO: Move to user configuration
    os = {
      wayland = lib.mkOption {
        type = bool;
        default = true;
        description = "Whether wayland is used on the system";
      };
    };
  };
}
