{
  inputs,
  ...
}:
{
  # Basic CLI environment

  flake.modules.nixos.cli =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        default-settings
        ssh
        git
        gitui
        fzf
        yazi
        shell-alias-cd-zoxide
        shell-alias-find-fd
        shell-alias-grep-rg
        shell-alias-ls-eza
      ];
    };
}
