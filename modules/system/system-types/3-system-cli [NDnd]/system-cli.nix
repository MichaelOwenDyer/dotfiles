{
  inputs,
  ...
}:
{
  # CLI environment - extends system-essential with basic CLI tools and services

  flake.modules.nixos.system-cli =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-essential
        ssh
      ];

      environment.systemPackages = with pkgs; [
        git
        vim
        curl
        wget
        ripgrep
        tree
        openssh
        gnupg1
      ];
    };

  flake.modules.darwin.system-cli =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        system-essential
        ssh
      ];

      environment.systemPackages = with pkgs; [
        git
        vim
        curl
        wget
        ripgrep
        tree
      ];
    };

  flake.modules.homeManager.system-cli = {
    imports = with inputs.self.modules.homeManager; [
      system-essential
    ];
  };
}
