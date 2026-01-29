{
  ...
}:
{
  # Bash shell - system default, always available

  flake.modules.nixos.bash-shell = {
    programs.bash.completion.enable = true;

    impermanence.ephemeralPaths = [
      "/etc/bashrc"
      "/etc/bash_logout"
      "/etc/inputrc" # Readline config (used by bash and other tools)
    ];
  };
}
