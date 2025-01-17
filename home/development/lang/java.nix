{ config, lib, pkgs, ... }:

{
  config.home-manager.users = let
    versions = with pkgs; {
      "8" = zulu8;
      "11" = zulu11;
      "17" = zulu17;
    };
  in lib.mapAttrs (username: profile: let javaConfig = profile.development.lang.java; in {
    # Enable Java for the user
    programs.java.enable = javaConfig.enable;
    # Add the main Java version to the PATH
    programs.java.package = versions.${javaConfig.mainVersion};
    # Install all additional Java versions (not in the PATH)
    home.packages = lib.map (version: versions.${version}) javaConfig.additionalVersions;
  }) config.profiles;
}