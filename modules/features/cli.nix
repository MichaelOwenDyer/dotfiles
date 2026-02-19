{
  inputs,
  ...
}:
{
  # Basic CLI environment

  flake.modules.nixos.cli =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        nh
        git
        gitui
        fzf
        yazi
        ide-helix
        nix-lang
        shell-alias-cd-zoxide
        fd
        ripgrep
        eza
      ];
    };

  flake.modules.darwin.cli =
    { ... }:
    {
      imports = with inputs.self.modules.darwin; [
        nh
        git
        gitui
        fzf
        yazi
        ide-helix
        nix-lang
        shell-alias-cd-zoxide
        fd
        ripgrep
        eza
      ];
    };

  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        nh
        git
        bat
        fzf
        yazi
        ide-helix
        nix-lang
        shell-alias-cd-zoxide
        fd
        ripgrep
        eza
      ];

      home.packages = with pkgs; [
        curl
        wget
        jq
      ];
    };
}
