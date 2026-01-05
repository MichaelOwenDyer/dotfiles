{
  inputs,
  ...
}:
{
  # Standalone Home-Manager configuration for michael
  # This allows using home-manager independently of NixOS/Darwin

  flake.homeConfigurations = {
    "michael@claptrap" = inputs.self.lib.mkHomeManager "x86_64-linux" "michael";
    "michael@rustbucket" = inputs.self.lib.mkHomeManager "x86_64-linux" "michael";
    "michael@mac" = inputs.self.lib.mkHomeManager "x86_64-darwin" "michael@mac";
  };
}
