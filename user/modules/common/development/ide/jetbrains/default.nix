{
  lib,
  util,
  ...
}:

{
  imports = [
    ./intellij-idea.nix
    ./rust-rover.nix
  ];

  # Declare configuration options for JetBrains IDEs under options.profiles.<name>.development.ide.jetbrains
  options = with lib.types; util.mkProfileOption lib {
    development.ide.jetbrains.plugins = lib.mkOption {
      type = listOf str;
      default = [];
      description = "Plugins to install in all JetBrains IDEs";
    };
  };
}
