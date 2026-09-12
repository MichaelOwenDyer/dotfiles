{
  ...
}:
{
  flake.modules.nixos.claude-code-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        claude-code
        mcp-nixos
      ];
    };

  flake.modules.darwin.claude-code-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        claude-code
        mcp-nixos
      ];
    };

  flake.modules.homeManager.claude-code-cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        claude-code
        mcp-nixos
      ];
    };
}
