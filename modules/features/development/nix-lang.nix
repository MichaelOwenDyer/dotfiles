{
  ...
}:
{
  flake.modules.nixos.nix-lang =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nixd
        nixfmt
        tree-sitter-grammars.tree-sitter-nix
      ];
    };

  flake.modules.darwin.nix-lang =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nixd
        nixfmt
        tree-sitter-grammars.tree-sitter-nix
      ];
    };

  flake.modules.homeManager.nix-lang =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nixd
        nixfmt
        tree-sitter-grammars.tree-sitter-nix
      ];
    };
}
