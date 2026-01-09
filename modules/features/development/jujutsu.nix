{
  ...
}:
{
  # jujutsu - a modern VCS

  flake.modules.nixos.jujutsu =
    { ... }:
    {
      programs.jujutsu.enable = true;
    };

  flake.modules.darwin.jujutsu =
    { ... }:
    {
      programs.jujutsu.enable = true;
    };

  flake.modules.homeManager.jujutsu =
    { ... }:
    {
      programs.jujutsu.enable = true;
    };
}