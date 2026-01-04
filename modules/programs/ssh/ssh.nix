{
  inputs,
  ...
}:
{
  # SSH server configuration

  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        UseDns = true;
        UsePAM = true;
      };
    };
  };

  flake.modules.darwin.ssh = {
    # Darwin SSH configuration (system preferences typically handle this)
  };
}
