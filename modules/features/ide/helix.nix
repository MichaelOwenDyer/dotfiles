{
  ...
}:
{
  # Helix editor configuration
  flake.modules.nixos.ide-helix =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.helix ];
    };

  flake.modules.darwin.ide-helix =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.helix ];
    };

  flake.modules.homeManager.ide-helix =
    { lib, pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        extraPackages = with pkgs; [
          yaml-language-server
          typescript-language-server
          java-language-server
          docker-language-server
          bash-language-server
          rust-analyzer
        ];
        defaultEditor = true;
        settings = {
          editor = {
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
            line-number = "relative";
            lsp.display-messages = true;
          };
          keys.normal = {
            esc = [ "collapse_selection" "keep_primary_selection" ];
            space = {
              q = ":q";
              space = "file_picker";
              w = ":w";
            };
          };
        };
        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt;
          }
        ];
      };
    };
}
