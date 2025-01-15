{ config, lib, pkgs, ... }:

{
  config.development.lang.java.enable = true;
  config.home-manager.users.${config.username} = let
    versions = with pkgs; {
      "8" = zulu8;
      "11" = zulu11;
      "17" = zulu17;
    };
  in {
    # Use programs.java to add a specific Java version to the PATH
    programs.java = {
      enable = true;
      package = versions.${config.development.lang.java.mainVersion};
    };
    # Install all additional Java versions (not in the PATH)
    home.packages = lib.map config.development.lang.java.additionalVersions (version: versions.${version});
  };
}