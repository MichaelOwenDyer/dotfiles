{
  ...
}:
{
  flake.modules.nixos.cursor-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cursor-cli
        mcp-nixos
      ];
    };

  flake.modules.darwin.cursor-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cursor-cli
        mcp-nixos
      ];
    };

  flake.modules.homeManager.cursor-cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cursor-cli
      ];
      home.file.".cursor/mcp.json".text = builtins.toJSON {
        mcpServers = {
          nixos = {
            command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
            args = [ ];
          };
        };
      };
    };
}
