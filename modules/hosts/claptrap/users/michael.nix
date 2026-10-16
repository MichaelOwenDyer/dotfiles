{
  inputs,
  ...
}:
{
  flake.modules.nixos.michael-claptrap =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael-claptrap ];
      };
    };

  flake.modules.homeManager.michael-claptrap =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        michael
        niri
        niri-outputs-claptrap
        dank-material-shell
        development
      ];

      home.stateVersion = "24.11";
    };

  flake.lib.keys.ssh.user."michael@claptrap" = {
    pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap";
    privateKeySecret = "ssh-michael-claptrap";
    deployPath = "/home/michael/.ssh/id_ed25519";
    owner = "michael";
  };
}
