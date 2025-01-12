{ config, settings, lib, pkgs, ... }:

{
  options.development.lang.java = {
    mainVersion = lib.mkOption {
      type = lib.types.enum [ "8" "11" "17" ];
      description = "Main Java version to install. Will be used as JAVA_HOME.";
    };
    additionalVersions = lib.mkOption {
      type = lib.types.listOf lib.types.enum [ "8" "11" "17" ];
      default = [ ];
      description = "Additional Java versions to install.";
    };
  };
  
  config.home-manager.users.${config.username} = let
    javaSettings = config.development.lang.java;
    versions = with pkgs; {
      "8" = zulu8;
      "11" = zulu11;
      "17" = zulu17;
    };
  in {
    # Use programs.java to add a specific Java version to the PATH
    programs.java = {
      enable = true;
      package = versions.${javaSettings.mainVersion};
    };
    # Install all additional Java versions (not in the PATH)
    home.packages = lib.map javaSettings.additionalVersions (version: versions.${version});
  };
}